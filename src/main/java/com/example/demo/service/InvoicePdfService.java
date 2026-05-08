package com.example.demo.service;

import com.example.demo.model.Invoice;
import com.example.demo.model.InvoiceItem;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.time.format.DateTimeFormatter;

@Service
public class InvoicePdfService {

    public ByteArrayInputStream generateInvoicePdf(Invoice inv) {
        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter.getInstance(document, out);
            document.open();

            // Font Definitions
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, BaseColor.BLUE);
            Font subHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.DARK_GRAY);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.BLACK);
            Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, BaseColor.BLACK);
            Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.GRAY);

            // Clinic Header
            Paragraph clinicName = new Paragraph("MEDICARE+ PHARMACY", headerFont);
            clinicName.setAlignment(Element.ALIGN_CENTER);
            document.add(clinicName);

            Paragraph clinicAddress = new Paragraph("123 Healthcare Ave, Medical District, City - 400001\nPhone: +91 98765 43210 | Email: pharmacy@medicare.com", smallFont);
            clinicAddress.setAlignment(Element.ALIGN_CENTER);
            document.add(clinicAddress);
            document.add(new Paragraph("\n"));
            document.add(new LineSeparator());
            document.add(new Paragraph("\n"));

            // Invoice Title
            Paragraph title = new Paragraph("TAX INVOICE", subHeaderFont);
            title.setAlignment(Element.ALIGN_RIGHT);
            document.add(title);
            document.add(new Paragraph("\n"));

            // Info Table
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            
            // Left: Patient Details
            PdfPCell patCell = new PdfPCell();
            patCell.setBorder(Rectangle.NO_BORDER);
            patCell.addElement(new Paragraph("BILL TO:", smallFont));
            patCell.addElement(new Paragraph(inv.getPatient().getName(), boldFont));
            patCell.addElement(new Paragraph("Patient ID: " + inv.getPatient().getPatientId(), normalFont));
            patCell.addElement(new Paragraph("Phone: " + inv.getPatient().getContactNumber(), normalFont));
            infoTable.addCell(patCell);

            // Right: Invoice Details
            PdfPCell invCell = new PdfPCell();
            invCell.setBorder(Rectangle.NO_BORDER);
            invCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            invCell.addElement(new Paragraph("Invoice No: " + inv.getInvoiceNumber(), boldFont));
            invCell.addElement(new Paragraph("Date: " + inv.getInvoiceDate().format(DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm")), normalFont));
            invCell.addElement(new Paragraph("Status: " + inv.getPaymentStatus(), normalFont));
            invCell.addElement(new Paragraph("Method: " + inv.getPaymentMethod(), normalFont));
            infoTable.addCell(invCell);

            document.add(infoTable);
            document.add(new Paragraph("\n"));

            // Items Table
            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            table.setWidths(new int[]{4, 1, 2, 1, 2});
            table.setSpacingBefore(10);

            // Table Headers
            String[] headers = {"Medicine Name", "Qty", "Unit Price", "Tax", "Total"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, boldFont));
                cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                cell.setPadding(8);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);
            }

            // Table Body
            for (InvoiceItem item : inv.getItems()) {
                table.addCell(new PdfPCell(new Phrase(item.getMedicine().getName(), normalFont)));
                table.addCell(new PdfPCell(new Phrase(String.valueOf(item.getQuantity()), normalFont)));
                table.addCell(new PdfPCell(new Phrase("INR " + item.getUnitPrice(), normalFont)));
                table.addCell(new PdfPCell(new Phrase("5%", normalFont)));
                table.addCell(new PdfPCell(new Phrase("INR " + item.getSubtotal(), normalFont)));
            }

            // Add Consultation Fee as a special row if present
            if (inv.getConsultationFee() != null && inv.getConsultationFee() > 0) {
                PdfPCell labelCell = new PdfPCell(new Phrase("Professional Consultation Fee", normalFont));
                labelCell.setColspan(4);
                labelCell.setPadding(8);
                labelCell.setBackgroundColor(new BaseColor(240, 248, 255)); // Light blue tint
                table.addCell(labelCell);

                PdfPCell valueCell = new PdfPCell(new Phrase("INR " + inv.getConsultationFee(), boldFont));
                valueCell.setPadding(8);
                valueCell.setBackgroundColor(new BaseColor(240, 248, 255));
                valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(valueCell);
            }
            document.add(table);

            // Totals
            PdfPTable totalTable = new PdfPTable(2);
            totalTable.setWidthPercentage(40);
            totalTable.setHorizontalAlignment(Element.ALIGN_RIGHT);
            totalTable.setSpacingBefore(20);

            double subtotal = inv.getTotalAmount() - inv.getTaxAmount();
            
            addTotalRow(totalTable, "Subtotal:", subtotal, normalFont);
            addTotalRow(totalTable, "GST (5%):", inv.getTaxAmount(), normalFont);
            addTotalRow(totalTable, "Grand Total:", inv.getTotalAmount(), boldFont);

            document.add(totalTable);

            // Footer
            document.add(new Paragraph("\n\n\n"));
            Paragraph footer = new Paragraph("Thank you for choosing MediCare+ Pharmacy!", smallFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

            document.close();

        } catch (DocumentException ex) {
            ex.printStackTrace();
        }

        return new ByteArrayInputStream(out.toByteArray());
    }

    private void addTotalRow(PdfPTable table, String label, double value, Font font) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, font));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPadding(5);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase("INR " + String.format("%.2f", value), font));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setPadding(5);
        table.addCell(valueCell);
    }
}

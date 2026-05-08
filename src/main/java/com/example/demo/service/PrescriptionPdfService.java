package com.example.demo.service;

import com.example.demo.model.Prescription;
import com.example.demo.model.PrescriptionItem;
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
public class PrescriptionPdfService {

    public ByteArrayInputStream generatePrescriptionPdf(Prescription rx) {
        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter.getInstance(document, out);
            document.open();

            // Font Definitions
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLUE);
            Font subHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.DARK_GRAY);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);
            Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.BLACK);

            // Clinic Header
            Paragraph clinicName = new Paragraph("MEDICARE+ CLINIC", headerFont);
            clinicName.setAlignment(Element.ALIGN_CENTER);
            document.add(clinicName);

            Paragraph clinicAddress = new Paragraph("123 Healthcare Ave, Medical District, City - 400001\nPhone: +91 98765 43210 | Email: contact@medicare.com", normalFont);
            clinicAddress.setAlignment(Element.ALIGN_CENTER);
            document.add(clinicAddress);
            document.add(new Paragraph("\n"));
            document.add(new LineSeparator());
            document.add(new Paragraph("\n"));

            // Doctor and Patient Info Table
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.setSpacingBefore(10);
            infoTable.setSpacingAfter(10);

            // Left Side: Doctor Info
            PdfPCell docCell = new PdfPCell();
            docCell.setBorder(Rectangle.NO_BORDER);
            docCell.addElement(new Paragraph("DOCTOR DETAILS", subHeaderFont));
            docCell.addElement(new Paragraph("Dr. " + rx.getDoctor().getFullName(), boldFont));
            docCell.addElement(new Paragraph(rx.getDoctor().getSpecialization(), normalFont));
            docCell.addElement(new Paragraph("License: " + rx.getDoctor().getLicenseId(), normalFont));
            infoTable.addCell(docCell);

            // Right Side: Patient Info
            PdfPCell patCell = new PdfPCell();
            patCell.setBorder(Rectangle.NO_BORDER);
            patCell.addElement(new Paragraph("PATIENT DETAILS", subHeaderFont));
            patCell.addElement(new Paragraph("Name: " + rx.getPatient().getName(), boldFont));
            patCell.addElement(new Paragraph("ID: " + rx.getPatient().getPatientId(), normalFont));
            patCell.addElement(new Paragraph("Age/Sex: " + rx.getPatient().getAge() + " / " + rx.getPatient().getGender(), normalFont));
            infoTable.addCell(patCell);

            document.add(infoTable);

            // Prescription ID and Date
            Paragraph rxInfo = new Paragraph("Prescription ID: " + rx.getPrescriptionId() + " | Date: " + rx.getCreatedAt().format(DateTimeFormatter.ofPattern("dd-MMM-yyyy")), normalFont);
            rxInfo.setSpacingAfter(20);
            document.add(rxInfo);

            // Medicines Table
            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100);
            table.setWidths(new int[]{3, 2, 2, 2, 1, 2});

            // Table Headers
            String[] headers = {"Medicine", "Dosage", "Frequency", "Duration", "Qty", "Relation"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, boldFont));
                cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                cell.setPadding(5);
                table.addCell(cell);
            }

            // Table Body
            for (PrescriptionItem item : rx.getItems()) {
                table.addCell(new PdfPCell(new Phrase(item.getMedicine().getName(), normalFont)));
                table.addCell(new PdfPCell(new Phrase(item.getDosage(), normalFont)));
                table.addCell(new PdfPCell(new Phrase(item.getFrequency(), normalFont)));
                table.addCell(new PdfPCell(new Phrase(item.getDuration(), normalFont)));
                table.addCell(new PdfPCell(new Phrase(String.valueOf(item.getQuantity()), normalFont)));
                table.addCell(new PdfPCell(new Phrase(item.getFoodRelation(), normalFont)));
            }

            document.add(table);

            if (rx.getNotes() != null && !rx.getNotes().isEmpty()) {
                document.add(new Paragraph("\nNotes:", boldFont));
                document.add(new Paragraph(rx.getNotes(), normalFont));
            }

            // Footer / Signature
            document.add(new Paragraph("\n\n\n\n"));
            Paragraph signature = new Paragraph("____________________\nDoctor's Signature", normalFont);
            signature.setAlignment(Element.ALIGN_RIGHT);
            document.add(signature);

            document.close();

        } catch (DocumentException ex) {
            ex.printStackTrace();
        }

        return new ByteArrayInputStream(out.toByteArray());
    }
}

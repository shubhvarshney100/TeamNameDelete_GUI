#ifndef PDFGENERATOR_H
#define PDFGENERATOR_H

#include <QString>

class PdfGenerator
{
public:
    // --- DEFINITIVE FIX: The function now accepts the raw data strings directly ---
    // This is a foolproof and robust way to pass the data.
    static void generateCertificate(const QString &filePath, const QString &date, const QString &time, const QString &drives);
};

#endif // PDFGENERATOR_H


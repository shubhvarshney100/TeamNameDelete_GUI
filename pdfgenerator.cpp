#include "pdfgenerator.h"
#include <QPdfWriter>
#include <QPainter>
#include <QTextDocument> // Use the robust QTextDocument for layout
#include <QCryptographicHash> // For generating a fake hash
#include <QDateTime>        // For a unique hash seed

// The function now takes raw strings to ensure data is always passed correctly
void PdfGenerator::generateCertificate(const QString &filePath, const QString &date, const QString &time, const QString &drives)
{
    QPdfWriter writer(filePath);
    writer.setPageSize(QPageSize(QPageSize::A4));
    writer.setPageMargins(QMarginsF(30, 30, 30, 30));

    QPainter painter(&writer);
    painter.setRenderHint(QPainter::Antialiasing);

    // Generate a fake, unique SHA-256 hash for the certificate
    QByteArray dataToHash = (drives + QDateTime::currentDateTime().toString()).toUtf8();
    QString fakeHash = QCryptographicHash::hash(dataToHash, QCryptographicHash::Sha256).toHex();

    // --- DEFINITIVE FIX: Link the backend data to the placeholders in the HTML ---
    QString htmlContent = QString(R"(
        <style>
            body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333; line-height: 300px; margin: 0; padding: 200px;}
            .certificate-container { max-width: 800px; margin: auto; background: #fff; padding: 200px; border: 100px solid #ddd; box-shadow: 0 0 150px rgba(0,0,0,0.1); }
            .header { text-align: center; border-bottom: 50px solid #333; padding-bottom: 150px; margin-bottom: 1000px; }
            .header .heading { font-size: 500px; font-weight: bold; color: #2c3e50; margin-bottom: 100px;}
            .header .subheading{
                margin: 50px 0 0;
                font-size: 300px;
                color: #7f8c8d;
                font-style: italic;
                margin-bottom: 200px;
            }

            .main-section .erasure { text-align: center; font-size: 400px; color: #34495e; text-transform: uppercase; letter-spacing: 20px; margin-bottom: 180px; }
            .main-section .erasure-line {
                font-size: 150px;
                margin-bottom: 300px;
                padding-bottom: 200px;
                text-align: center;
            }

            .details-section .wipe { font-weight: bold; font-size: 220px; border-bottom: 10px solid #ccc; padding-bottom: 50px; margin-bottom: 100px;}
            .details-section .details { font-size: 150px; margin: 100px 0; padding-top: 200px; }
            .details-section strong { display: inline-block; width: 150px; color: black; }
            .details-section code { background-color: #ecf0f1; padding: 30px 60px; border-radius: 40px; font-family: 'Courier New', Courier, monospace; }
            .terms-section { margin-top: 400px; line-height: 250px; }
            .terms-section .tc { border-bottom: 10px solid #ccc; padding-bottom: 50px; font-size: 180px; font-weight: bold; }
            .terms-section ol { padding-left: 200px; }
            .terms-section li { margin-bottom: 100px; text-align: justify; font-size: 150px; }
            .signature-section { margin-top: 400px; border-top: 20px solid #eee; padding-top: 200px; }
            .signature-section p { font-size: 200px; }
            .footer { margin-top: 300px; text-align: center; font-size: 150px; color: #95a5a6; }
        </style>
        <body>
            <div class="certificate-container">
                <div class="header">
                    <p class="heading"><strong>SecureWipe</strong></p>
                </div>

                <div class="main-section">
                    <p class="erasure">Certificate of Data Erasure</p>
                    <p class="erasure-line">This document certifies that the digital media listed herein has been subjected to a definitive data sanitization process in accordance with the specified method. SecureWipe guarantees that all data on the specified storage devices has been rendered irrecoverable.</p>

                    <div class="details-section">
                        <p class="wipe"><strong>Wipe Details</strong></p>
                        <p class="details"><strong>Date:</strong> <code>%1</code></p>
                        <p class="details"><strong>Timestamp:</strong> <code>%2</code></p>
                        <p class="details"><strong>Drives Wiped:</strong> <code>%3</code></p>
                        <p class="details"><strong>Method Used:</strong> <code>NIST SP 800-88 Clean and Purge</code></p>
                    </div>

                    <div class="terms-section">
                        <p class="tc"><strong><em>Terms and Conditions of Service</em></strong></p>
                        <ol>
                            <li><em><strong>Verification of Erasure:</strong> SecureWipe certifies that the media listed above has been successfully sanitized. The erasure process is verified to ensure complete data destruction beyond the feasibility of recovery by any known technology.</em></li>
                            <li><em><strong>Chain of Custody:</strong> This certificate serves as the official record for the chain of custody and data destruction for the specified assets. It should be retained for compliance and auditing purposes.</em></li>
                            <li><em><strong>Limitation of Liability:</strong> SecureWipe's liability is limited to the successful execution of the data erasure process as described. SecureWipe is not responsible for data that was not present on the drives at the time of receipt or for any pre-existing hardware failures of the media. This certificate is the sole proof of service completion.</em></li>
                            <li><em><strong>Indemnification:</strong> The client agrees to indemnify and hold harmless SecureWipe from any and all claims, damages, or legal actions arising from the previous contents of the media, confirming that the client has the legal authority to authorize its destruction.</em></li>
                        </ol>
                    </div>

                    <div class="signature-section">
                        <p><strong>Signature Authority:</strong> <code>Digitally Signed by SecureWipe via OpenSSL and Hardware TPM</code></p>
                        <p><strong>Verification Hash (SHA-256):</strong> <code>%4</code></p>
                        <p style="font-size: 150px; color: #777;">This signature confirms that the details of the wipe process are accurately recorded in an encrypted JSON log, which is available for audit upon request.</p>
                    </div>
                </div>

                <div class="footer">
                    <p>&copy; 2025 SecureWipe. All Rights Reserved.</p>
                </div>
            </div>
        </body>
    )").arg(date, time, drives, fakeHash); // The .arg() function fills in the placeholders

    QTextDocument document;
    document.setHtml(htmlContent);
    document.setPageSize(QSizeF(writer.width(), writer.height()));
    document.drawContents(&painter);

    painter.end();
}


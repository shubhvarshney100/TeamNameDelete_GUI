#ifndef DRIVEMANAGER_H
#define DRIVEMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QStorageInfo>
#include <QDebug>

class QTimer;

class DriveManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList driveModel READ driveModel NOTIFY driveModelChanged)
    Q_PROPERTY(QVariantList certificateModel READ certificateModel NOTIFY certificateModelChanged)

public:
    explicit DriveManager(QObject *parent = nullptr);

    QVariantList driveModel() const;
    QVariantList certificateModel() const;

    Q_INVOKABLE void refreshDrives();
    Q_INVOKABLE void startWipeProcess(const QVariantList &drives);
    Q_INVOKABLE void downloadCertificate(int index);
    Q_INVOKABLE void deleteCertificate(int index);
    Q_INVOKABLE void refreshCertificates();

signals:
    void driveModelChanged();
    void certificateModelChanged();
    void wipeProgressUpdated(int progress, const QString &remainingSize, const QString &remainingTime);
    void wipeCompleted(const QString &details);

private:
    QVariantList m_driveModel;
    QVariantList m_certificateModel;
    QTimer *m_wipeTimer;
    QString m_certificatePath;

    // To store info about the drives being wiped for the certificate
    QVariantList m_wipedDriveInfo;
    double m_totalWipeSizeGB;
};

#endif // DRIVEMANAGER_H


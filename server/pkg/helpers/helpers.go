package helpers

import (
	"net/smtp"
	"server/config"
)

// SendEmail sends an email by using smtp protocol
func SendEmail(smtpData *config.SmtpData, to []string, message []byte) error {
	auth := smtp.PlainAuth("", smtpData.Mail, smtpData.Password, smtpData.Host)
	err := smtp.SendMail(smtpData.Host+":"+smtpData.Port, auth, smtpData.Mail, to, message)
	return err
}


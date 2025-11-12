import smtplib, os
from dotenv import load_dotenv
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

load_dotenv()

from_email = os.getenv('EMAIL_ADDRESS')
password = os.getenv('EMAIL_PASSWORD')
smtp_server = os.getenv('SMTP_SERVER', 'smtp.gmail.com')
smtp_port = int(os.getenv('SMTP_PORT', 587))

def send_email(to_email, subject, body):

    # Create the email

    try:

        msg = MIMEMultipart()
        msg['From'] = from_email
        msg['To'] = to_email
        msg['Subject'] = subject

        msg.attach(MIMEText(body, 'plain'))

        # Connect to the server
        with smtplib.SMTP_SSL(smtp_server, smtp_port) as server:
            server.login(from_email, password)
            server.sendmail(from_email, to_email, msg.as_string())

        print(f"Email sent to {to_email}")

    except Exception as e:
        print(f"Failed to send email: {e}")


if __name__ == "__main__":
    print("Sending test email...")
    send_email('akolawale4@gmail.com', 'Test Subject', 'This is the second test email body.')
    print("Test email process completed.")

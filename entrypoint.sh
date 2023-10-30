#!/bin/sh

# Assign command line arguments to variables
DOMAIN=$1
FROM_EMAIL=$2
TO_EMAIL=$3
SUBJECT=$4
DESCRIPTION=$5

# Update the ssmtp configuration with the provided domain
SSMTP_CONF="/etc/ssmtp/ssmtp.conf"
echo "root=postmaster" > $SSMTP_CONF
echo "mailhub=smtp.$DOMAIN:587" >> $SSMTP_CONF
echo "hostname=$DOMAIN" >> $SSMTP_CONF
echo "FromLineOverride=YES" >> $SSMTP_CONF
# Assume AuthUser and AuthPass are set as environment variables
echo "AuthUser=$SMTP_USER" >> $SSMTP_CONF
echo "AuthPass=$SMTP_PASS" >> $SSMTP_CONF
echo "UseSTARTTLS=YES" >> $SSMTP_CONF

# Log the ssmtp configuration update
echo "Updated ssmtp configuration."

# Create a temporary file to hold the email content
EMAIL_FILE=$(mktemp)
if [ $? -ne 0 ]; then
    echo "Failed to create temporary email file."
    exit 1
fi

# Write the email content to the temporary file
echo "To: $TO_EMAIL" > $EMAIL_FILE
echo "From: $FROM_EMAIL" >> $EMAIL_FILE
echo "Subject: $SUBJECT" >> $EMAIL_FILE
echo "" >> $EMAIL_FILE
echo "$DESCRIPTION" >> $EMAIL_FILE

# Log the email content creation
echo "Created email content."

# Send the email using ssmtp
ssmtp $TO_EMAIL < $EMAIL_FILE
if [ $? -ne 0 ]; then
    echo "Failed to send email."
    exit 1
fi

# Log the email sending
echo "Sent email to $TO_EMAIL."

# Remove the temporary email file
rm $EMAIL_FILE
if [ $? -ne 0 ]; then
    echo "Failed to remove temporary email file."
    exit 1
fi

# Log the temporary email file removal
echo "Removed temporary email file."

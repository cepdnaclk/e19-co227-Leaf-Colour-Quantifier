import gdown

# Replace 'YOUR_GOOGLE_DRIVE_LINK' with your Google Drive sharing link
# Make sure the link is set to 'Anyone with the link can view/download'
file_url = 'https://drive.google.com/file/d/1T-CTsVM4R-TGmyF0sOGzu8Ar3sgMbY4D/view?usp=drive_link'

output = "model_01.pth"
# gdown.download(file_url, output, quiet=False)

gdown.download(url=file_url, output=output, quiet=False, fuzzy=True)
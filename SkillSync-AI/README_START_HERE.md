# SkillSync AI — Start Here

This is the student-friendly package for your Cloud Computing mini-project.

## First: open the website on your laptop (no AWS setup needed)

1. Download `SkillSync_AI_Project.zip` and extract it.
2. Open the extracted `SkillSync_AI` folder.
3. Double-click **`START_HERE.bat`**.
4. Your browser should open `http://localhost:5500`.
5. Click **Use a sample resume instead**.
6. Click **Insert sample job description**.
7. Click **Analyze resume**.

The page will show a working sample report.

### Important: two modes

- **Local Demo Mode** (the default): runs in your browser and compares skill keywords. This is useful to learn the interface and demonstrate the workflow, but it is **not a generative-AI result** and does not contact AWS.
- **AWS Bedrock Mode**: after the AWS backend is deployed and its Lambda Function URL is pasted into `config.js`, the same website sends the PDF and job description to AWS Lambda. Lambda stores the PDF in private S3 and asks Amazon Bedrock to generate the analysis.

The website clearly labels which mode is active. Do not describe a Local Demo Mode result as an Amazon Bedrock result.

## What each file is

| File | Purpose |
|---|---|
| `index.html` | Website structure and content |
| `styles.css` | Colours, layout and responsive design |
| `app.js` | PDF reading, buttons, demo comparison and AWS request |
| `config.js` | AWS backend URL (blank until configured) |
| `sample-files/sample-resume.pdf` | Fictional PDF for testing the demo |
| `backend/lambda_function.py` | Python code that runs on AWS Lambda |
| `backend/iam-policy-template.json` | Starting IAM permissions for S3 and Bedrock |
| `START_HERE.bat` | Starts the local website on Windows |
| `AWS_DEPLOYMENT_GUIDE.md` | Step-by-step cloud deployment checklist |
| `VIVA_NOTES.md` | Short project explanation and likely viva questions |

## If START_HERE.bat does not open the page

- Make sure Python 3 is installed. During Python installation, select **Add Python to PATH**.
- Keep the black terminal/server window open.
- Open `http://localhost:5500` manually in Chrome or Edge.
- The PDF reader loads from a CDN, so an internet connection is needed to read PDF files.

## What I need you to do

For the first local run, only extract the ZIP and double-click `START_HERE.bat`. Do not create AWS resources yet. Once the local sample report works, continue with `AWS_DEPLOYMENT_GUIDE.md`.

## Safety and academic use

Use fictional resumes for the college demonstration. The score is an approximate skills-evidence comparison, not a validated measure of a person's ability or a recommendation to hire or reject someone. Do not upload real candidates' personal documents without permission.

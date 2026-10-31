# AWS Deployment Guide — SkillSync AI

This guide is for the second stage, after the local demo works. AWS setup requires access to your own AWS account and may incur charges. Never share your password, access keys, secret keys or billing information.

## Architecture

Browser (HTML/CSS/JavaScript) → Lambda Function URL → Python AWS Lambda → private S3 bucket + Amazon Bedrock (Nova Lite).

The browser reads selectable PDF text using PDF.js. Lambda stores the original PDF in S3, then sends the extracted text and the job description to Bedrock. The website receives a structured JSON report.

## A. Create the private resume bucket

1. Sign in at https://console.aws.amazon.com/ and select **Asia Pacific (Mumbai) — ap-south-1**.
2. Open Amazon S3 and create a globally unique bucket, for example `skillsync-resumes-yourname-2026`.
3. Keep **Block all public access** enabled.
4. Keep default encryption enabled.
5. Do not enable static website hosting on this bucket.
6. Record the exact bucket name.

## B. Check Amazon Bedrock model availability

1. Open Amazon Bedrock in the Mumbai region.
2. Open model access / model catalog and confirm that Amazon Nova Lite is available to your account.
3. The Lambda code defaults to the APAC cross-Region inference profile ID `apac.amazon.nova-lite-v1:0` for Mumbai. Cross-Region inference can route model processing to supported APAC destination Regions; check current AWS documentation and your institution's data rules before using it.
4. If the model/profile is unavailable to your account, stop here and resolve model access before deploying Lambda. Do not claim the Bedrock integration works until a real test succeeds.

## C. Create the Lambda execution role

1. Open IAM → Roles → Create role.
2. Trusted entity: **AWS service**; use case: **Lambda**.
3. Attach the AWS-managed policy `AWSLambdaBasicExecutionRole` for CloudWatch logs.
4. Add an inline policy based on `backend/iam-policy-template.json`.
5. Replace `REPLACE_WITH_YOUR_PRIVATE_BUCKET_NAME` with the bucket name from section A.
6. Replace `REPLACE_WITH_YOUR_12_DIGIT_ACCOUNT_ID` with your AWS account ID if required by the inference-profile ARN in the policy.
7. Review the policy and save it. The policy grants S3 upload only to the `resumes/` prefix and Bedrock invocation permissions for the listed Nova Lite inference profile/model resources. If AWS IAM validation reports an ARN or permission issue, follow the exact resource ARN shown in the Bedrock console/model documentation for your account and region.

## D. Create the Lambda function

1. Open AWS Lambda → Create function → Author from scratch.
2. Function name: `skillsync-resume-analyzer`.
3. Runtime: Python 3.12 (or another currently supported Python 3 runtime available in the console).
4. Architecture: x86_64.
5. Select the IAM role created in section C.
6. After creation, open the Code tab and upload `SkillSync_Lambda_Deploy.zip` (or ZIP `backend/lambda_function.py` yourself with `lambda_function.py` at the ZIP root).
7. Set the handler to `lambda_function.lambda_handler`.
8. In Configuration → General configuration, set timeout to 60 seconds and memory to 512 MB.
9. In Configuration → Environment variables, add:
   - `RESUME_BUCKET` = the exact private bucket name
   - `BEDROCK_MODEL_ID` = `apac.amazon.nova-lite-v1:0`
10. Save and Deploy.

## E. Create the Function URL

1. In the Lambda function, open Configuration → Function URL → Create function URL.
2. For a short classroom test only, select Auth type `NONE`.
3. Set CORS allowed origins to `*` while testing, allowed methods to `POST`, and allowed headers to `content-type`.
4. Create the Function URL and copy the complete HTTPS URL. It should end in `.on.aws/`.
5. Important: `NONE` makes the function publicly invocable. CORS is not authentication. Keep this as a temporary demo endpoint, monitor AWS usage and delete/disable it after the evaluation. A real public service needs authentication, throttling and abuse protection.

## F. Connect the website to Lambda

1. Open `config.js` in the project folder.
2. Set `API_URL` to the complete Lambda Function URL, keeping the trailing slash:

```js
window.APP_CONFIG = {
  API_URL: "https://YOUR_FUNCTION_URL.lambda-url.ap-south-1.on.aws/"
};
```

3. Save the file and refresh the local website.
4. The top-right status should now say **AWS BEDROCK CONNECTED**. This only means a URL is configured; verify with a real request before claiming successful cloud analysis.
5. Upload the fictional sample resume and submit the sample job description. A successful report should be labelled **AMAZON BEDROCK ANALYSIS**.

## G. Host the frontend publicly on S3

Do this only after the backend works locally.

1. Create a second S3 bucket for the website, separate from the private resume bucket.
2. Upload only these four frontend files to the website bucket: `index.html`, `styles.css`, `app.js`, `config.js`.
3. Enable Static website hosting and set the index document to `index.html`.
4. For a basic class demo, you may configure public read access for the website files only, after understanding the warning in the S3 console. Never make the resume bucket public.
5. Open the S3 website endpoint shown in Properties → Static website hosting.
6. Update the Lambda Function URL CORS allowed origin to the exact website origin shown in the browser address bar.
7. S3 static website endpoints use HTTP. To demonstrate HTTPS, place CloudFront in front of the website bucket. Do not put personal data or private resumes in the public website bucket.

## Test checklist

- [ ] Local site opens at `http://localhost:5500`.
- [ ] The fictional sample resume is accepted and PDF text is extracted.
- [ ] Local demo report appears (this is keyword matching only).
- [ ] Private S3 bucket has Block Public Access enabled.
- [ ] Lambda can write one test PDF under `resumes/`.
- [ ] Bedrock model/profile can be invoked from Lambda.
- [ ] Website status changes to AWS Bedrock configured.
- [ ] A real AWS request returns a report labelled Amazon Bedrock analysis.
- [ ] Public endpoint is disabled/restricted after the demonstration.

## Troubleshooting

- **PDF reader did not load:** check internet access; PDF.js is loaded from a CDN.
- **CORS error:** check the Function URL CORS origin, method `POST`, and allowed header `content-type`. Set the origin to the exact site origin after hosting.
- **S3 AccessDenied:** verify `RESUME_BUCKET` and `s3:PutObject` on `arn:aws:s3:::YOUR_BUCKET/resumes/*`.
- **Bedrock AccessDenied/model error:** verify model access, inference profile ID, region and `bedrock:InvokeModel` resources in the Lambda role.
- **Timeout:** test with a shorter resume and retain a 60-second Lambda timeout.
- **No text extracted:** use a PDF with selectable text; scanned image-only PDFs are not supported by this version.

## AWS cost and privacy reminder

S3 storage, Lambda invocations, Bedrock inference and CloudFront (if used) may incur charges. Check AWS pricing and billing alerts before deployment. Use only a made-up resume for the class demo. Delete uploaded sample files and remove/disable the public Function URL when no longer needed.

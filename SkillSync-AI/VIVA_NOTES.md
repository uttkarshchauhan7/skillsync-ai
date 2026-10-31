# SkillSync AI — Viva Notes

## 30-second introduction

"Our project is SkillSync AI, an AI-assisted resume screening system. It compares a candidate's resume with a job description and presents matching skills, skills that are not clearly mentioned, strengths and improvement suggestions. The frontend is built with HTML, CSS and JavaScript. In the cloud version, Python AWS Lambda handles the backend, Amazon S3 stores the uploaded PDF privately, and Amazon Bedrock generates the analysis. It is designed to support human review, not to make automatic hiring decisions."

## Explain it in simple words

1. A recruiter uploads a PDF resume and enters a job description.
2. JavaScript uses PDF.js to extract selectable text from the PDF in the browser.
3. The website sends the resume text, job description and PDF data to AWS Lambda.
4. Lambda checks the request and saves the original PDF in a private S3 bucket.
5. Lambda sends the resume text and job description to Amazon Bedrock.
6. Bedrock returns a structured analysis in JSON.
7. Lambda sends the result to the website, and JavaScript displays it.

## What each technology does

- **HTML:** defines the page structure and form controls.
- **CSS:** controls page layout, colours, spacing and responsive design.
- **JavaScript:** handles upload, reads PDF text, calls the backend and displays results.
- **Python:** implements backend request handling inside Lambda.
- **Amazon S3:** object storage for the original PDF resume.
- **AWS Lambda:** runs backend code on demand without managing a server.
- **Amazon Bedrock:** provides access to a foundation model for resume/job-description comparison.

## Likely viva questions

**Q1. What problem does your project solve?**  
Manually comparing resumes with job requirements takes time. Our system summarizes the evidence and skills relevant to a particular job description.

**Q2. Why did you use Amazon S3?**  
S3 is object storage. We use it to store the original PDF separately from the website code. The resume bucket remains private.

**Q3. Why AWS Lambda?**  
Lambda runs backend code when a request arrives. We do not need to create or maintain an always-running EC2 server for this small application.

**Q4. Why Amazon Bedrock?**  
Bedrock provides managed access to foundation models through an API. We can use a model without training one from scratch.

**Q5. Does S3 analyse resumes?**  
No. S3 stores files. Lambda coordinates the processing, and Bedrock performs the language analysis.

**Q6. What is PDF text extraction?**  
It is the process of reading selectable text from PDF pages. Our browser uses PDF.js. This version does not perform OCR on scanned image-only PDFs.

**Q7. What is serverless computing?**  
It means the cloud provider manages the underlying server infrastructure. We deploy the function code and AWS runs it when invoked.

**Q8. What is the limitation of the match score?**  
It is an approximate comparison of skills and evidence in two documents. It is not scientifically validated and must not be treated as a candidate's probability of job success.

**Q9. Can the system reject a candidate automatically?**  
No. It is a decision-support demonstration. A human must review the full application and context.

**Q10. What is the difference between Local Demo Mode and AWS mode?**  
Local Demo Mode uses a simple keyword comparison in the browser and does not call AWS. AWS mode calls the Python Lambda backend, which stores the PDF in S3 and requests analysis from Bedrock.

## Do not claim these things unless you have tested them

- Do not say the local keyword demo is powered by Bedrock.
- Do not say the website is deployed on AWS until you open its public URL.
- Do not say the PDF is stored in S3 unless you verify the object in the private S3 bucket.
- Do not say the AI score predicts job performance.

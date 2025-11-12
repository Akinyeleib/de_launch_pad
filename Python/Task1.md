# Project 1: [ZenQuotes API](https://zenquotes.io/)

## Project Title
Build an automated quote email delivery platform using ZenQuotes API. Get quotes from the API and automate daily sending to subscribers’ email

## Project Overview
You’ve been contracted by **MindFuel**, a mental wellness startup.  
They want to send motivational quotes to subscribed users every morning at **7 AM**.

Your job is to build a **production-grade backend service** that:
- Pulls a new quote daily from ZenQuotes API  
- Personalizes and sends it to subscribed users via email  
- Logs activity and handles failures  
- Can scale to hundreds or thousands of users

---

## Deliverables

### 1. ZenQuotes API
- Fetch quote from the API: [https://zenquotes.io/](https://zenquotes.io/)
- Handle edge cases:
  - No response
  - Malformed response

### 2. User Subscription Management
Create a `users` table in any database management system of your choice (e.g., Postgres, MySQL, SQL Server).  
Each user should have:
- Email address  
- Name  
- Subscription status (active/inactive)  
- Email frequency preference (daily/weekly)

### 3. Email Module
- Send personalized quotes
- Handle failures and retries
- Log email delivery status per user

### 4. Logging & Monitoring
- Log events to files
  - Quote fetched
  - Email sent (to which user, when)
  - Failures and retry attempts
- Send email summary logs to admin (e.g., daily email with stats)

### 5. Documentation
- Provide a clear and detailed `README.md` file for your project.

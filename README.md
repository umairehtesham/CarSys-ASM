CarSys Showroom Management System (MASM / Irvine32)

This repository contains a complete **Car Showroom Management System** implemented in **MASM (x86 Assembly)** using the **Irvine32 library**.  
The program manages a car inventory of up to 10 cars, with full support for:

✔ Purchasing cars  
✔ Selling cars  
✔ Displaying car details  
✔ Profit/Loss reporting  
✔ Bargaining logic  
✔ Color-coded console output  

---

🚗 Features Overview

🔹 Purchase a Car
- Accepts car condition (1–10)
- Rejects cars with condition ≤ 5  
- Accepts only valid model names  
- Budget validation  
- Bargaining mode for high-priced cars  
- Automatically assigns Car ID  
- Updates purchase/sale price and budget  

🔹 Sell a Car
- Enter a car ID to sell  
- Validates ID  
- Adds sales price to showroom budget  

🔹 Display Inventory
Shows:
- Car ID  
- Model name  
- Selling price  

🔹 Profit/Loss Report
- Initial budget: **10,000,000**
- Shows remaining budget  
- Calculates:
  - Profit  
  - Loss  
  - No Profit/No Loss  

---

🛠 Requirements

To run this program, you need:

- MASM (Microsoft Macro Assembler)
- Irvine32 Library  
  Download from Kip Irvine’s official site.

Libraries used:
- `Irvine32.inc`
- `Irvine32.lib`
- `Kernel32.lib`
- `User32.lib`

---

👤 Author
**Umair Ehtesham**  
**Rumaesa Faisal Seth**
**Ameerah** 
GitHub: https://github.com/umairertesham


# Rust Single-Threaded Web Server

This project implements a simple single-threaded web server in Rust that serves HTML pages with interactive JavaScript elements.

## Lab Objectives Completed

**1. Single-threaded Rust server** - Implemented following the Rust Book tutorial
**2. Two HTML webpages** - Created index.html, page1.html, and page2.html
**3. Two links with unique messages** - Main page links to two pages, each passing different messages via URL parameters
**4. Serve webpages** - Server successfully serves all HTML files
**5. Interactive JavaScript** - Page 1 includes a button with a popup alert

## Files

- `main.rs` - The Rust web server implementation
- `index.html` - Main homepage with links to other pages
- `page1.html` - First linked page with interactive JavaScript button
- `page2.html` - Second linked page displaying passed messages

## How to Run

### Using rustc (simple compilation)
```bash
rustc main.rs
./main
```
### Running in VS 
'''ensure rust analyzer extension is installed 
rustc main.rs
.\main.exe 
'''
### Accessing the Server

Once the server is running, open your web browser and navigate to:
```
http://127.0.0.1:7878
```

## Features

### URL Parameter Passing
- The main page links include query parameters (e.g., `?message=Hello`)
- JavaScript on each page extracts and displays these messages
- Demonstrates client-side data passing between pages

### Interactive Elements
- **Page 1** includes a button that displays a popup alert when clicked
- This fulfills the interactive JavaScript requirement

### Navigation
- All pages include links back to the home page
- Clean, styled interface with responsive design

## Technical Details

- **Server**: Single-threaded TCP listener on port 7878
- **Protocol**: HTTP/1.1
- **Content Type**: HTML
- **JavaScript**: Vanilla JavaScript for URL parsing and interaction
- **Styling**: Embedded CSS for clean presentation

## Testing

1. Start the server
2. Visit http://127.0.0.1:7878
3. Click "Visit Page 1" - you should see the passed message displayed
4. Click the interactive button - a popup should appear
5. Go back and click "Visit Page 2" - you should see a different message
6. All navigation links should work correctly

## Notes

- The server runs on `127.0.0.1:7878` (localhost)
- Press `Ctrl+C` to stop the server
- Make sure all HTML files are in the same directory as the executable
- This is a learning project and not intended for production use

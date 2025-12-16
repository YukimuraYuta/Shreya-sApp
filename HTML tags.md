Document structure

<!DOCTYPE>  <!DOCTYPE html>
<html></html>
<head></head>
<title>Page Title</title>
<body>...</body>

Text and content

<h>Main Heading</h>
<p>This is a paragraph.</p>
<br>
<hr> thematic break (horizontal)
<strong>.   <p>This is **important**!</p> used to define imp text
<em> renders as italic
<span>. <p>Hello <span style="color:red;">World</span></p>
<div>Content Section</div>. block level comtainer

Links and images

<a href="url">Link Text</a>
<img src="image.jpg" alt="Description">
<ul><li>Item</li>...</ul>. bulleted list
<ol><li>Item</li>...<ol>. numbered list
<li>List Item Content</li>. defines a list item within <ul> and <ol>

Forms and input

<form action="/submit" method="post">...</form>
Used to create an HTML form for user input.
<input type="text" name="username">
<label for="id">Name:</label>
defines label for an input
<button type="submit">Submit</button>

Semantic layout

<header><h1>Website Name</h1></header>
<nav><ul>...</ul></nav>. defines a set of navigation link
<main>...</main>
<article>...</article>
<section>...</section>
<footer><p>&copy; 2025</p></footer>

other essential

Metadata - Used for setting character sets, viewport settings, and SEO info.
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

Script- Scripting. Used to embed or reference executable code, primarily JavaScript. Essential for application interactivity.
<script src="app.js"></script>

div- Generic Container. A block-level element used for grouping content for styling (CSS) or manipulation (JavaScript).
<div>This is a section.</div>

aside- Sidebar/Tangential Content. Content tangentially related to the content around it (e.g., a sidebar or callouts).
<aside>Related Links</aside>

textarea-Multi-line Text. A control for entering multi-line text (for comments, descriptions, etc.).
<textarea name="comment" rows="4" cols="50"></textarea>

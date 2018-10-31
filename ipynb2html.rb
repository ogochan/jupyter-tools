require 'rubygems'
require 'nokogiri'

html = STDIN.read
doc = Nokogiri::HTML.parse(html)

print <<__HEAD__
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<head>
<meta charset="utf-8" />
<title></title>
<style>
body {
    margin: 0 auto;
    padding: 2em 2em 4em;
     font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-size: 16px;
    line-height: 1.5em;
}

h1, h2, h3, h4, h5, h6 {
    color: #222;
    font-weight: 600;
    line-height: 1.3em;
}

h2 {
    margin-top: 1.3em;
}

a {
    color: #0083e8;
}

b, strong {
    font-weight: 600;
}
p {
	text-indent: 1em;
	margin-left: 20px;
}

ul, ol {
	margin-left: 20px;
}

samp {
    display: none;
}

img {
    background: transparent;
    display: block;
    margin: 1.3em auto;
    max-width: 95%;
}

pre {
    font-family: 'Consolas', 'Deja Vu Sans Mono',
                 'Bitstream Vera Sans Mono', monospace;
    font-size: 0.95em;
    line-height: 120%;
    padding: 0.5em;
    border: 1px solid #ccc;
    background-color: #f8f8f8;
}

pre a {
    color: inherit;
    text-decoration: underline;
}


table,
td,
th
{
	border: 1px solid;
}

td, th {
	padding: 5px;
}

th {
	text-align: center;
}

pre,
blockquote,
img,
table {
    page-break-inside: avoid;
}

hr.page {
	display: none;
}

@media print {
	h1.page, h2.page {
		page-break-before: always;
	}
}
</style>
</head>
<body>
__HEAD__

doc = doc.xpath('//body/div[@class="border-box-sizing"]/div[@class="container"]')

doc.search('//a[@class="anchor-link"]').map &:remove

doc.search('//table').each do | table |
  table["border"] = 1
  table["cellpadding"] = 0
  table["cellspacing"] = 0
end

doc.xpath('//div[@class="inner_cell"]/*/*').each do | inner_cell |
  print inner_cell.to_s
  print "\n"
end

print "</body>\n</html>\n"

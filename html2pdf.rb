# -*- coding: utf-8 -*-
require 'chrome_remote'
require 'base64'
 
class PdfWriter
  def initialize()
    @chrome = ChromeRemote.client
    @chrome.send_cmd 'Network.enable'  # Navigateに必要
    @chrome.send_cmd 'Page.enable'     # Pageオブジェクトの操作に必要
    @chrome.send_cmd 'Runtime.enable'  # JavaScript実行に必要
  end
 
  def to_pdf(uri)
    @chrome.send_cmd('Page.navigate', url:uri)
    @chrome.wait_for('Page.loadEventFired')
    # ロード後に数秒実行に必要なJavaScriptが動くとしたらここで待機するか、またはイベントをチェックする必要がある。
=begin
    JavaScriptの呼出しには、Runtime.evaluateを使う
    ret = @chrome.send_cmd 'Runtime.evaluate', expression: "document.getElementById("foobar').baz()"
=end
    ret = @chrome.send_cmd('Page.printToPDF', 
                           dispalyHEaderFooter:false,  # これがやりたかったことだ
                           printBackground: false,
                           paperHeight: 11.7,
                           paperWidth: 8.3) # A4: 11.7inch * 8.3inch
    @chrome.send_cmd('Browser.close')
    ret['data']  # JSONが返されてdataプロパティにBase64エンコードされたPDFが格納されている
  end
 
  def to_pdf_file(file, uri)
    data = to_pdf(uri)
    File.open(file, 'wb') do |fout|
      fout.write(Base64.decode64(data))
    end
  end
end

if ( ARGV.size > 0 )
  html_fn = ARGV[0]
  uri = "file:///#{File.expand_path(html_fn)}"
  if ( ARGV[1] )
    out_fn = ARGV[1]
  else
    out_fn = "#{File.basename(html_fn, '.*')}.pdf"
  end
  pdf = PdfWriter.new
  pdf.to_pdf_file(out_fn, uri)
else
  print "Usage: html2pdf <HTML file name> [ <PDF file name> ]\n"
end

require 'html-proofer'

HTML_DIR = "./public"

task :html_proofer do
    html_proofer_opts = {
        :check_html       => true,
        :empty_alt_ignore => true,
        :typhoeus => {
          :ssl_verifypeer => false,
          :ssl_verifyhost => 0 }
    }
    HTMLProofer.check_directory(HTML_DIR, html_proofer_opts).run
end

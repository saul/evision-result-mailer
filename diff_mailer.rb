require 'dotenv'
Dotenv.load

require 'json'
require 'base64'
require 'mail'
require 'hashdiff'

require_relative 'result_scraper'
require_relative 'mail_config'

LAST_RESULTS_FILE = 'last_results.cache'

def mail_results(diff_lines)
  diff_body = diff_lines.join "\n"
  puts diff_body

  Mail.deliver do
    to ENV['GMAIL_EMAIL']
    from "eVision Bot <#{ENV['GMAIL_EMAIL']}>"

    subject 'eVision Assessment Change'
    body <<EOF
Changes to your eVision assessment results:

#{diff_body}
EOF
  end
end

def diff_results(last_results, new_results)
  HashDiff.diff(last_results, new_results).map do |key_diff|
    cmp, title, value, *rest = key_diff

    case cmp
    when '-'
      "REMOVED: #{title} #{value}"
    when '~'
      new_value = rest[0]
      "CHANGED: #{title} #{value} -> #{new_value}"
    when '+'
      "ADDED: #{title} #{value}"
    end
  end
end

def scrape_finished(results)
  last_results = JSON.parse File.read(LAST_RESULTS_FILE) if File.exist? LAST_RESULTS_FILE

  puts '[*] Comparing last results with new'
  diff_lines = diff_results(last_results || {}, results)

  if diff_lines.length > 0
    puts '[*] DIFFERENT! Sending results email'
    mail_results diff_lines
  else
    puts '[*] Results identical'
  end

  puts '[*] Saving results'
  File.write LAST_RESULTS_FILE, results.to_json
end

scraper = ResultScraper.new

puts '[*] Scraping'
scraper.scrape host: ENV['EVISION_HOST'], username: ENV['EVISION_USERNAME'], password: Base64.decode64(ENV['EVISION_PASSWORD'])

scrape_finished scraper.results

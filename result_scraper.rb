require 'capybara/dsl'
require 'capybara/poltergeist'

# Capybara.default_driver = :selenium
Capybara.default_driver = :poltergeist

class ResultScraper
  include Capybara::DSL

  def results
    @results ||= {}
  end

  def scrape(host:, username:, password:)
    puts '1. Logging in'
    login(host, username, password)

    puts '2. Retrieving module list'
    visit_modules

    puts '3. Crawling modules'
    crawl_modules
  end

  private

  def login(host, username, password)
    visit host
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Log in'

    fail "Unexpected host after login `#{page.current_host}`" unless page.current_host == host
  end

  def visit_modules
    click_on 'Module and Assessment Results'
    click_on 'Select'
  end

  def check_components
    find(:table, 'Assessment components').all('tbody tr').each do |row|
      # table header cells in tbody... sigh
      next unless row.has_no_selector? 'th'

      cells = row.all 'td'
      title = cells[0].text
      weight = cells[1].text
      unconfirmed = cells[3].text
      mark = cells[4].text

      mark_text = if mark != '-'
                    "#{mark}%"
                  elsif unconfirmed == '-'
                    '-'
                  else
                    "#{unconfirmed}% (UNCONFIRMED)"
                  end

      fail "Assessment `#{title}` already seen" unless results[title].nil?
      results[title] = mark_text
    end
  end

  def crawl_modules(index = 0)
    rows = find(:table, 'module results').all('tbody tr')

    latest_year = rows.last.all('td')[0].text

    row = rows[index]

    cells = row.all('td')
    year = cells[0].text
    title = cells[2].text
    puts "#{year}: #{title}"

    if year == latest_year
      row.click_on 'More'
      check_components
      click_on 'Back'
    else
      puts '  (skipped old module)'
    end

    return crawl_modules(index + 1) if index < rows.length - 1
  end
end

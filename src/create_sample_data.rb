require 'csv'

file_path = "src/sample.csv"

data_size = 1_200_000

headers = %w[id name address updated_at point years_residence]

DATETIME_FROM = DateTime.parse('2022-01-01 00:00:00')
DATETIME_TO   = DateTime.parse('2022-12-31 00:00:00')

def random_date
  rand(DATETIME_FROM..DATETIME_TO)
end

CSV.open(file_path, 'w', encoding: 'utf-8', force_quotes: true) do |csv|
  csv << headers
  1.upto(data_size) do |i|
    csv << [
      i,
      "user_#{i}",
      "address_#{i}",
      random_date,
      rand(0..100),
      rand(0...40)
    ]
  end
end

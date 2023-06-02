require 'aws-sdk-s3'
require 'csv'
require 'benchmark'

profile_name = 'seri-dev'
bucket_name = 's3-slect-test'

s3_client = Aws::S3::Client.new(profile: profile_name, region: 'ap-northeast-1')

key = 'target_sample.csv'

# 与えられた ids 配列の id で検索し、id と name だけ抽出するクエリを作成する
def build_query(output_items, ids)
  <<~QUERY
    SELECT
    #{output_items.map{|item| "s.#{item}"}.join(', ')}
    FROM S3Object s
    WHERE s.id IN ('#{ids.join("', '")}')
  QUERY
end

# `#select_object_content` に渡すパラメータを作成する
def build_params(bucket, key, query)
  {
    bucket: bucket,
    key: key,
    expression_type: 'SQL',
    expression: query,
    input_serialization: {
      # field_delimiter を "\t" にすることでタブ区切りのファイルにも対応可能
      csv: { file_header_info: 'USE', allow_quoted_record_delimiter: true, record_delimiter: "\n", field_delimiter: ',' }
    },
    output_serialization: {
      csv: { record_delimiter: "\n", field_delimiter: ',' }
    }
  }
end

output_items = %w[id name address updated_at point years_residence]
query = build_query(output_items, [1, 123456])
puts "S3 Select query: <<~QUERY\n#{query}QUERY"
params = build_params(bucket_name, key, query)

response = nil
result = Benchmark.realtime do
  puts "S3 Select request start"
  # S3 Select を使ってレスポンスを取得する
  response = s3_client.select_object_content(params)
end

puts "S3 Select request: #{result}s"

# `#event_type == :records` の中にレコード（抽出されたデータ）が含まれる
csv_list = response.payload.select { |p| p.event_type == :records }.map(&:payload).map(&:read)
csv = CSV.parse(csv_list.join)

# マルチバイト文字列を扱う場合
csv.map do |row|
  row.map { |r| r.force_encoding('UTF-8') }
end

p csv

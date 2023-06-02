require 'aws-sdk-s3'

profile_name = 'seri-dev'
bucket_name = 's3-slect-test'

s3 = Aws::S3::Resource.new(profile: profile_name, region: 'ap-northeast-1')

key = 'target_sample.csv'

# サンプル用のデータをアップロードする
s3_object = s3.bucket(bucket_name).object(key)

progress = Proc.new do |bytes, totals|
  @last_percentage ||= 0
  percentage = (100.0 * bytes.sum / totals.sum).floor
  if percentage >= @last_percentage + 5
    puts "Uploading...#{percentage}%"
    @last_percentage = percentage
  end
end
s3_object.upload_file('src/sample.csv', progress_callback: progress)

# s3-select-sample

### sample.csvファイルの作成
```bash
$ bundle exec ruby src/create_sample_data.rb
```

### sample.csvファイルをS3にアップロード
```bash
$ bundle exec ruby src/upload_sample.rb
```

### S3 Selectの実行（検証）
```bash
$ bundle exec ruby src/s3_select.rb
```

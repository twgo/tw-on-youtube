# tw-on-youtube

本專案利用 youtube-dl 取得線上聲音資源以訓練語音辨識

[一鍵啟動](https://github.com/twgo/tw-on-youtube/wiki/%E5%AE%89%E8%A3%9Ddocker-compose%E4%B8%80%E9%8D%B5%E5%95%9F%E7%94%A8-Ruby-on-Rails-%E6%9C%8D%E5%8B%99)

## 啟動

```bash
#!/bin/bash
# clone 專案
git clone https://github.com/twgo/tw-on-youtube.git
# 啟動 docker.app
cd tw-on-youtube
docker-compose build
docker-compose run web rails db:create
docker-compose run web rails db:migrate RAILS_ENV=development
docker-compose up -d
#可至 localhost:3000 進行操作
```

## 終止

```bash
#!/bin/bash
docker-compose down
可順利關閉
若連不上可能是上次 ctrl c 關掉不順利
可至tmp/pids/ 刪掉 server.pid
接著重跑
docker-compose up
即可一鍵啟用
```

## 下載影片

- 採mp4，為通用格式

## 批次下載影片

- 可輸入含 `list=` 或 `/channel/` 連結，會根據給的網址下的影片通抓

## 聲音轉檔

- 採 wav：為辨識所需格式

## 儲存字幕

- 採vtt：vtt較srt多了來源語言類型，預設下載 zh-Hant, zh-Hans, en ，即繁中簡中英文。

## 記錄資訊

- 凡影片提供有助語音辨識之基本資訊將記錄，例：聲音之位元率(abr)...

## 結構說明

## DownloadWorker

輸入影片位址後將於背景後台下載影片

## View

- 輸入影片來源：目前限 youtube 單片、清單(playlist)與頻道(channel)

## Controller

- 新增影片
- 檢視全部已下載影片

## Model

status 下載狀態
yid youtube 影片 id
format_downloaded 已下載之檔案格式
subtitle_downloaded 已下載之字幕語系
其它為 youtube-dl 提供之 metadata

## 討論板

歡迎於 https://gitter.im/twgo/Lobby 留言給我們意見

## 語料格式化

- 為符合辨識用語料需求，下載音檔將格式化成為能被 Kaldi 直接使用之語料，並含對照文件以利查看來源影片

### 語料格式化規格

- 下載之影片音檔被收錄在資料夾，自動以下列規則命名存檔路徑
  - 'output': 'public/download/%(ext)s/%(channel_id)s/%(channel_id)s%-(playlist_id)s-%(id)s.%(ext)s',
- 下載之影片清單提供下載

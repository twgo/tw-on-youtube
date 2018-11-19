# tw-on-youtube
[![Build](https://travis-ci.org/twgo/tw-on-youtube.svg?branch=master)](https://travis-ci.org/twgo/tw-on-youtube)
[![Coverage Status](https://coveralls.io/repos/github/twgo/tw-on-youtube/badge.svg?branch=master)](https://coveralls.io/github/twgo/tw-on-youtube?branch=master)  [![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/twgo/Lobby) [![](https://img.shields.io/docker/build/leo424y/tw-on-youtube.svg)](https://hub.docker.com/r/leo424y/tw-on-youtube/)

# 安裝準備
[一鍵啟動](https://github.com/twgo/tw-on-youtube/wiki/%E5%AE%89%E8%A3%9Ddocker-compose%E4%B8%80%E9%8D%B5%E5%95%9F%E7%94%A8-Ruby-on-Rails-%E6%9C%8D%E5%8B%99)

# 啟動
clone 專案
git clone https://github.com/twgo/tw-on-youtube.git
啟動 docker.app 在專案根目錄
docker-compose build
docker-compose run web rails db:create
docker-compose run web rails db:migrate RAILS_ENV=development
docker-compose up -d
應能一鍵啟用服務
可至
localhost:3000
進行操作

# 終止
docker-compose down
可順利關閉
若連不上可能是上次 ctrl c 關掉不順利
可至tmp/pids/ 刪掉 server.pid
接著重跑
docker-compose up
即可一鍵啟用



# 專案目的
本專案利用 youtube-dl 取得線上聲音資源以訓練語音辨識

# 已開發功能
## 下載影片
- 採mp4，為通用格式

## 批次下載影片
- 可輸入含 `list=` 或 `/channel/` 連結，會根據給的網址下的影片通抓

## 聲音轉檔
- 採opus：由於原始音多opus, m4a 直轉 youtube-dl 轉wav 大倍10，故取opus為聲音格式

## 儲存字幕
- 採vtt：vtt較srt多了來源語言類型，預設下載 zh-Hant, zh-Hans, en ，即繁中簡中英文。

## 記錄資訊
- 凡影片提供有助語音辨識之基本資訊將記錄，例：聲音之位元率(abr)...

# 待開發功能
- 關鍵字搜尋與下載

# 結構說明

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

# 討論板
歡迎於 https://gitter.im/twgo/Lobby 留言給我們意見

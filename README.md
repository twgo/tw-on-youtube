# tw-on-youtube
[![Build](https://travis-ci.org/twgo/tw-on-youtube.svg?branch=master)](https://travis-ci.org/twgo/tw-on-youtube)
[![Coverage Status](https://coveralls.io/repos/github/twgo/tw-on-youtube/badge.svg?branch=master)](https://coveralls.io/github/twgo/tw-on-youtube?branch=master)  [![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/twgo/Lobby)

# 安裝
docker-compose up --build (測試中	)

# 專案目的
本專案取得影片資源以訓練語音辨識

# 功能
## 下載影片
- 採mp4，為通用格式

## 聲音轉檔
- 採opus：由於原始音多opus, m4a 直轉 youtube-dl 轉wav 大倍10，故取opus為聲音格式

## 字幕
- 採vtt：vtt較srt多了來源語言類型

## 批次下載影片
-[ ] youtubd-dl會根據給的網址下含多少影片通抓，應能處理大批量來原輸入

# 結構說明

## DownloadWorker
登錄影片位址後將於後台下載影片

## View
- 輸入影片來源：目前限youtube單片，清單下載功能開發中

## Controller
- 新增影片
- 檢視全部已輸入影片

## Model
status 下載狀態
yid youtube影片id
format_downloaded 已下載之檔案格式

# 討論板
歡迎於 https://gitter.im/twgo/Lobby 留言給我們意見

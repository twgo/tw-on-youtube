# tw-on-youtube
[![Build](https://travis-ci.org/twgo/tw-on-youtube.svg?branch=master)](https://travis-ci.org/twgo/tw-on-youtube)
[![Coverage Status](https://coveralls.io/repos/github/twgo/tw-on-youtube/badge.svg?branch=master)](https://coveralls.io/github/twgo/tw-on-youtube?branch=master)  [![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/twgo/Lobby)

# 安裝
[一鍵啟動](https://github.com/twgo/tw-on-youtube/wiki/%E5%AE%89%E8%A3%9Ddocker-compose%E4%B8%80%E9%8D%B5%E5%95%9F%E7%94%A8%E6%9C%8D%E5%8B%99)

# 專案目的
本專案取得影片資源以訓練語音辨識

# 功能
## 下載影片
- 採mp4，為通用格式

## 批次下載影片
- 可輸入playlist: youtubd-dl 會根據給的網址下的影片通抓

## 聲音轉檔
- 採opus：由於原始音多opus, m4a 直轉 youtube-dl 轉wav 大倍10，故取opus為聲音格式

## 字幕
- 採vtt：vtt較srt多了來源語言類型

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
subtitle_downloaded 已下載之字幕語系
其它為 youtube-dl 提供之 metadata

# 討論板
歡迎於 https://gitter.im/twgo/Lobby 留言給我們意見

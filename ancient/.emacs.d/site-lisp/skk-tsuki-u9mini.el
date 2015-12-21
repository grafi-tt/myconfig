;; -*- coding: iso-2022-jp -*-
;; SKK で月配列U8を使う。
;; [YK] massangeana氏の花配列のEmacs Lispを月配列用に改変。
;;      (see http://www.massangeana.com/mas/charsets/hana/hanasetup.htm#skk)
;;      コメント中の [YK] は改変者による付記を表す。
;;

(when (not (boundp 'skk-hana-ansi)) (setq skk-hana-ansi nil))

(require 'skk-kanagaki-util)

(setq skk-special-midashi-char-list nil) ;全キー通常の文字入力で使用

;; skk-auto-start-henkan-keyword-list はそのままでよい。

(if (not skk-hana-ansi)
    (progn
      ;; lq,.@ は除く。[YK] 花でのQの役割をTにあてる。月では '?' は除外
      (setq skk-set-henkan-point-key 
            '(?A ?B ?C ?D ?E ?F ?G ?H ?I ?J ?K ?L ?M ?N ?O ?P ?Q ?R ?S ?U ?V ?W ?X ?Y ?Z
                 ?+ ?*  ?< ?>))
      ;; 106 キー用の大文字・小文字変換テーブル。
      (setq skk-downcase-alist 
            '((?< . ?,) (?> . ?.) (?+ . ?\;) (?\* . ?:)))
      )
    (progn
      (setq skk-set-henkan-point-key 
            '(?A ?B ?C ?D ?E ?F ?G ?H ?I ?J ?K ?L ?M ?N ?O ?P ?Q ?R ?S ?U ?V ?W ?X ?Y ?Z
                 ?: ?\" ?< ?>))
      (setq skk-downcase-alist 
            '((?< . ?,) (?> . ?.) (?: . ?\;) (?\" . ?')))
))

;; `-' で前候補を表示。
(setq skk-previous-candidate-char ?-)

(setq skk-process-okuri-early nil)	; ローマ字変換の時以外は意味なし。


;; copied from skk-kanagaki.el

(defun skk-kanagaki-set-okurigana (&optional no-sokuon)
  "ポイントの直前の文字を送り仮名と見倣して、変換を開始する。
ただし、 もうひとつ前の文字が促音だった場合には、 それ以降を送り仮名と見倣す。"
  (interactive)
  (let ((pt1 (point))
	pt2 okuri sokuon)
    (setq okuri
	  (skk-save-point
	    ;; うう、こんなことをしなければならないのか...
	    (backward-char 1)
	    (buffer-substring-no-properties
	     (setq pt2 (point))
	     pt1)))
    (when okuri
      (unless no-sokuon
	(setq sokuon
	      (skk-save-point
		(backward-char 2)
		(buffer-substring-no-properties
		 (point)
		 pt2)))
	(unless (member sokuon '("っ" "ッ"))
	  (setq sokuon nil)))
      ;;
      (skk-save-point
	(backward-char (if sokuon 2 1))
	(skk-set-marker skk-okurigana-start-point
			(point)))
      (setq skk-okuri-char (skk-okurigana-prefix okuri))
      (unless skk-current-search-prog-list
	(setq skk-current-search-prog-list
	      skk-search-prog-list))
      (skk-set-okurigana))))
;; end copy



(setq skk-rom-kana-rule-list nil)


(setq skk-rom-kana-base-rule-list-jis
      '(
	(":" nil skk-abbrev-mode)
	("@" nil skk-toggle-kana)
	("`" nil skk-latin-mode)
	("{" nil skk-jisx0208-latin-mode)

	("]" nil skk-purge-from-jisyo)
      ))

(setq skk-rom-kana-base-rule-list-ansi
      '(
	("'" nil skk-abbrev-mode)
	("[" nil skk-toggle-kana)
	("{" nil skk-latin-mode)
	("}" nil skk-jisx0208-latin-mode)

	("`" nil skk-purge-from-jisyo)
	("@" nil skk-today)
      ))

(setq skk-rom-kana-base-rule-list-all
      '(
	("?" nil skk-today)  ;; [YK] もと "`"
    ("\n" nil skk-kakutei)
	("T" nil skk-set-henkan-point-subr)  ;; [YK] 花では Q
	("$" nil skk-display-code-for-char-at-point)
	("d\\" nil skk-input-by-code-or-menu)

	("q" nil ("ュ" . "ゅ"))   ("kq" nil ("ィ" . "ぃ"))   ("lq" nil "「")
	("w" nil ("ト" . "と"))   ("kw" nil ("ャ" . "ゃ"))   ("lw" nil ("ド" . "ど"))
	("e" nil ("シ" . "し"))   ("ke" nil ("ネ" . "ね"))   ("le" nil ("ジ" . "じ"))
	("r" nil ("コ" . "こ"))   ("kr" nil ("ラ" . "ら"))   ("lr" nil ("ゴ" . "ご"))
	("t" nil ("ョ" . "ょ"))   ("kt" nil ("メ" . "め"))   ("lt" nil "〜")
	("y" nil ("ツ" . "つ"))   ("dy" nil ("ヌ" . "ぬ"))   ("sy" nil ("ヅ" . "づ"))
	("u" nil ("ウ" . "う"))   ("du" nil ("ム" . "む"))   ("su" nil ("ヴ" . "う゛"))
	("i" nil ("イ" . "い"))   ("di" nil ("ホ" . "ほ"))   ("si" nil ("ボ" . "ぼ"))
	("o" nil ("カ" . "か"))   ("do" nil ("エ" . "え"))   ("so" nil ("ガ" . "が"))
	("p" nil ("リ" . "り"))   ("dp" nil ("ゥ" . "ぅ"))   ("sp" nil "」")

	("a" nil ("ハ" . "は"))   ("ka" nil ("ユ" . "ゆ"))   ("la" nil ("バ" . "ば"))
	                          ("ks" nil ("ヨ" . "よ"))   ("ls" nil ("パ" . "ぱ"))
	                          ("kd" nil ("ケ" . "け"))   ("ld" nil ("ゲ" . "げ"))
	("f" nil ("テ" . "て"))   ("kf" nil ("ア" . "あ"))   ("lf" nil ("デ" . "で"))
	("g" nil ("タ" . "た"))   ("kg" nil ("レ" . "れ"))   ("lg" nil ("ダ" . "だ"))
	("h" nil ("ク" . "く"))   ("dh" nil ("マ" . "ま"))   ("sh" nil ("グ" . "ぐ"))
	("j" nil ("ン" . "ん"))   ("dj" nil ("オ" . "お"))   ("sj" nil "ー")
	                          ("dk" nil ("チ" . "ち"))   ("sk" nil ("ヂ" . "ぢ"))
	                          ("dl" nil ("ソ" . "そ"))   ("sl" nil ("ゾ" . "ぞ"))
	(";" nil ("キ" . "き"))   ("d;" nil ("ミ" . "み"))   ("s;" nil ("ギ" . "ぎ"))

	("z" nil ("ス" . "す"))   ("kz" nil ("ァ" . "ぁ"))   ("lz" nil ("ズ" . "ず"))
	("x" nil ("ヲ" . "を"))   ("kx" nil ("ヤ" . "や"))   ("lx" nil ("プ" . "ぷ"))
	("c" nil ("ニ" . "に"))   ("kc" nil ("セ" . "せ"))   ("lc" nil ("ゼ" . "ぜ"))
	("v" nil ("ナ" . "な"))   ("kv" nil ("フ" . "ふ"))   ("lv" nil ("ブ" . "ぶ"))
	("b" nil ("サ" . "さ"))   ("kb" nil ("ェ" . "ぇ"))   ("lb" nil ("ザ" . "ざ"))
	("n" nil ("ッ" . "っ"))   ("dn" nil ("ヒ" . "ひ"))   ("sn" nil ("ビ" . "び"))
	("m" nil ("ル" . "る"))   ("dm" nil ("ワ" . "わ"))   ("sm" nil ("ピ" . "ぴ"))
	("," nil ("ノ" . "の"))   ("d," nil ("ロ" . "ろ"))   ("s," nil ("ポ" . "ぽ"))
	("." nil ("モ" . "も"))   ("d." nil ("ォ" . "ぉ"))   ("s." nil ("ペ" . "ぺ"))
	("/" nil ("ヘ" . "へ"))   ("d/" nil "・")            ("s/" nil ("べ" . "べ"))

	("ssm" nil ("ヮ" . "ゎ"))
	("ssi" nil ("ヰ" . "ゐ"))
	("sse" nil ("ヱ" . "ゑ"))
	("sso" nil "ヵ")
	("ssd" nil "ヶ")
	("ddh" nil "←")
	("ddj" nil "↓")
	("ddk" nil "↑")
	("ddl" nil "→")
	("dd," nil "‥")
	("dd." nil "…")
	("dd-" nil "〜")
	("llq" nil "『")
	("ssp" nil "』")
	
	("df" nil skk-current-touten)
	("kj" nil skk-current-kuten)
	("sf" nil "！")
	("lj" nil "？")
	))


(setq skk-rom-kana-base-rule-list
      (append 
       (if (not skk-hana-ansi) skk-rom-kana-base-rule-list-jis skk-rom-kana-base-rule-list-ansi)
       skk-rom-kana-base-rule-list-all))

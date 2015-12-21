;; -*- coding: iso-2022-jp -*-
;; SKK $B$G7nG[Ns(BU8$B$r;H$&!#(B
;; [YK] massangeana$B;a$N2VG[Ns$N(BEmacs Lisp$B$r7nG[NsMQ$K2~JQ!#(B
;;      (see http://www.massangeana.com/mas/charsets/hana/hanasetup.htm#skk)
;;      $B%3%a%s%HCf$N(B [YK] $B$O2~JQ<T$K$h$kIU5-$rI=$9!#(B
;;

(when (not (boundp 'skk-hana-ansi)) (setq skk-hana-ansi nil))

(require 'skk-kanagaki-util)

(setq skk-special-midashi-char-list nil) ;$BA4%-!<DL>o$NJ8;zF~NO$G;HMQ(B

;; skk-auto-start-henkan-keyword-list $B$O$=$N$^$^$G$h$$!#(B

(if (not skk-hana-ansi)
    (progn
      ;; lq,.@ $B$O=|$/!#(B[YK] $B2V$G$N(BQ$B$NLr3d$r(BT$B$K$"$F$k!#7n$G$O(B '?' $B$O=|30(B
      (setq skk-set-henkan-point-key 
            '(?A ?B ?C ?D ?E ?F ?G ?H ?I ?J ?K ?L ?M ?N ?O ?P ?Q ?R ?S ?U ?V ?W ?X ?Y ?Z
                 ?+ ?*  ?< ?>))
      ;; 106 $B%-!<MQ$NBgJ8;z!&>.J8;zJQ49%F!<%V%k!#(B
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

;; `-' $B$GA08uJd$rI=<(!#(B
(setq skk-previous-candidate-char ?-)

(setq skk-process-okuri-early nil)	; $B%m!<%^;zJQ49$N;~0J30$O0UL#$J$7!#(B


;; copied from skk-kanagaki.el

(defun skk-kanagaki-set-okurigana (&optional no-sokuon)
  "$B%]%$%s%H$ND>A0$NJ8;z$rAw$j2>L>$H8+Jo$7$F!"JQ49$r3+;O$9$k!#(B
$B$?$@$7!"(B $B$b$&$R$H$DA0$NJ8;z$,B%2;$@$C$?>l9g$K$O!"(B $B$=$l0J9_$rAw$j2>L>$H8+Jo$9!#(B"
  (interactive)
  (let ((pt1 (point))
	pt2 okuri sokuon)
    (setq okuri
	  (skk-save-point
	    ;; $B$&$&!"$3$s$J$3$H$r$7$J$1$l$P$J$i$J$$$N$+(B...
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
	(unless (member sokuon '("$B$C(B" "$B%C(B"))
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
	("?" nil skk-today)  ;; [YK] $B$b$H(B "`"
    ("\n" nil skk-kakutei)
	("T" nil skk-set-henkan-point-subr)  ;; [YK] $B2V$G$O(B Q
	("$" nil skk-display-code-for-char-at-point)
	("d\\" nil skk-input-by-code-or-menu)

	("q" nil ("$B%e(B" . "$B$e(B"))   ("kq" nil ("$B%#(B" . "$B$#(B"))   ("lq" nil "$B!V(B")
	("w" nil ("$B%H(B" . "$B$H(B"))   ("kw" nil ("$B%c(B" . "$B$c(B"))   ("lw" nil ("$B%I(B" . "$B$I(B"))
	("e" nil ("$B%7(B" . "$B$7(B"))   ("ke" nil ("$B%M(B" . "$B$M(B"))   ("le" nil ("$B%8(B" . "$B$8(B"))
	("r" nil ("$B%3(B" . "$B$3(B"))   ("kr" nil ("$B%i(B" . "$B$i(B"))   ("lr" nil ("$B%4(B" . "$B$4(B"))
	("t" nil ("$B%g(B" . "$B$g(B"))   ("kt" nil ("$B%a(B" . "$B$a(B"))   ("lt" nil "$B!A(B")
	("y" nil ("$B%D(B" . "$B$D(B"))   ("dy" nil ("$B%L(B" . "$B$L(B"))   ("sy" nil ("$B%E(B" . "$B$E(B"))
	("u" nil ("$B%&(B" . "$B$&(B"))   ("du" nil ("$B%`(B" . "$B$`(B"))   ("su" nil ("$B%t(B" . "$B$&!+(B"))
	("i" nil ("$B%$(B" . "$B$$(B"))   ("di" nil ("$B%[(B" . "$B$[(B"))   ("si" nil ("$B%\(B" . "$B$\(B"))
	("o" nil ("$B%+(B" . "$B$+(B"))   ("do" nil ("$B%((B" . "$B$((B"))   ("so" nil ("$B%,(B" . "$B$,(B"))
	("p" nil ("$B%j(B" . "$B$j(B"))   ("dp" nil ("$B%%(B" . "$B$%(B"))   ("sp" nil "$B!W(B")

	("a" nil ("$B%O(B" . "$B$O(B"))   ("ka" nil ("$B%f(B" . "$B$f(B"))   ("la" nil ("$B%P(B" . "$B$P(B"))
	                          ("ks" nil ("$B%h(B" . "$B$h(B"))   ("ls" nil ("$B%Q(B" . "$B$Q(B"))
	                          ("kd" nil ("$B%1(B" . "$B$1(B"))   ("ld" nil ("$B%2(B" . "$B$2(B"))
	("f" nil ("$B%F(B" . "$B$F(B"))   ("kf" nil ("$B%"(B" . "$B$"(B"))   ("lf" nil ("$B%G(B" . "$B$G(B"))
	("g" nil ("$B%?(B" . "$B$?(B"))   ("kg" nil ("$B%l(B" . "$B$l(B"))   ("lg" nil ("$B%@(B" . "$B$@(B"))
	("h" nil ("$B%/(B" . "$B$/(B"))   ("dh" nil ("$B%^(B" . "$B$^(B"))   ("sh" nil ("$B%0(B" . "$B$0(B"))
	("j" nil ("$B%s(B" . "$B$s(B"))   ("dj" nil ("$B%*(B" . "$B$*(B"))   ("sj" nil "$B!<(B")
	                          ("dk" nil ("$B%A(B" . "$B$A(B"))   ("sk" nil ("$B%B(B" . "$B$B(B"))
	                          ("dl" nil ("$B%=(B" . "$B$=(B"))   ("sl" nil ("$B%>(B" . "$B$>(B"))
	(";" nil ("$B%-(B" . "$B$-(B"))   ("d;" nil ("$B%_(B" . "$B$_(B"))   ("s;" nil ("$B%.(B" . "$B$.(B"))

	("z" nil ("$B%9(B" . "$B$9(B"))   ("kz" nil ("$B%!(B" . "$B$!(B"))   ("lz" nil ("$B%:(B" . "$B$:(B"))
	("x" nil ("$B%r(B" . "$B$r(B"))   ("kx" nil ("$B%d(B" . "$B$d(B"))   ("lx" nil ("$B%W(B" . "$B$W(B"))
	("c" nil ("$B%K(B" . "$B$K(B"))   ("kc" nil ("$B%;(B" . "$B$;(B"))   ("lc" nil ("$B%<(B" . "$B$<(B"))
	("v" nil ("$B%J(B" . "$B$J(B"))   ("kv" nil ("$B%U(B" . "$B$U(B"))   ("lv" nil ("$B%V(B" . "$B$V(B"))
	("b" nil ("$B%5(B" . "$B$5(B"))   ("kb" nil ("$B%'(B" . "$B$'(B"))   ("lb" nil ("$B%6(B" . "$B$6(B"))
	("n" nil ("$B%C(B" . "$B$C(B"))   ("dn" nil ("$B%R(B" . "$B$R(B"))   ("sn" nil ("$B%S(B" . "$B$S(B"))
	("m" nil ("$B%k(B" . "$B$k(B"))   ("dm" nil ("$B%o(B" . "$B$o(B"))   ("sm" nil ("$B%T(B" . "$B$T(B"))
	("," nil ("$B%N(B" . "$B$N(B"))   ("d," nil ("$B%m(B" . "$B$m(B"))   ("s," nil ("$B%](B" . "$B$](B"))
	("." nil ("$B%b(B" . "$B$b(B"))   ("d." nil ("$B%)(B" . "$B$)(B"))   ("s." nil ("$B%Z(B" . "$B$Z(B"))
	("/" nil ("$B%X(B" . "$B$X(B"))   ("d/" nil "$B!&(B")            ("s/" nil ("$B$Y(B" . "$B$Y(B"))

	("ssm" nil ("$B%n(B" . "$B$n(B"))
	("ssi" nil ("$B%p(B" . "$B$p(B"))
	("sse" nil ("$B%q(B" . "$B$q(B"))
	("sso" nil "$B%u(B")
	("ssd" nil "$B%v(B")
	("ddh" nil "$B"+(B")
	("ddj" nil "$B"-(B")
	("ddk" nil "$B",(B")
	("ddl" nil "$B"*(B")
	("dd," nil "$B!E(B")
	("dd." nil "$B!D(B")
	("dd-" nil "$B!A(B")
	("llq" nil "$B!X(B")
	("ssp" nil "$B!Y(B")
	
	("df" nil skk-current-touten)
	("kj" nil skk-current-kuten)
	("sf" nil "$B!*(B")
	("lj" nil "$B!)(B")
	))


(setq skk-rom-kana-base-rule-list
      (append 
       (if (not skk-hana-ansi) skk-rom-kana-base-rule-list-jis skk-rom-kana-base-rule-list-ansi)
       skk-rom-kana-base-rule-list-all))

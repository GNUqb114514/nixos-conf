{
  pkgs,
  lib,
  config,
  ...
}@args: let cfg = config.user.emacs; ulib = import ./lib.nix args; in {
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.emacs.extraConfig = ''
(setopt org-agenda-files '("~/org"))
(setopt org-log-done 'time)
(setopt org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\\\.org\\\\'" . org-mode))
(add-hook 'org-mode-hook 'org-indent-mode)

(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c c") 'org-capture)

(defun decode-time-mdy (time)
  "Decode timestamp time to (MONTH DAY YEAR)."
  (let ((lst (decode-time time)))
    (list (nth 4 lst) (nth 3 lst) (nth 5 lst))))

(defun my-feeder-oi-problem ()
  (interactive)
  (let* ((title (read-string "题目在洛谷中的标题（如 P1001 A+B Problem）"))
         (link (replace-regexp-in-string "\\([^ ]+\\)\\( .*\\)?" "[[https://www.luogu.com.cn/problem/\\1][\\&]]" title t))
         (deadline (org-read-date nil nil nil "截止时间" nil "+3d"))
         (creation (format-time-string "[%Y-%m-%d %a %H:%M]" (org-current-time)))
         (subtree (format "* 未提交 [#B] OI 题目 %s\n:Created: %s\nDEADLINE: <%s>\n"
                          link creation deadline)))
    subtree))

(defun my-locator-end-of-subtree (prev)
  "A locator to the end of the subtree PREV."
  (lambda ()
    (funcall prev)
    (org-end-of-subtree t)))

(defun my-locator-monthly-datetree-in (date prev)
  "A locator to the date in format (MONTH DAY YEAR) returned by function DATE in the datetree in PREV."
  (lambda ()
    (funcall prev)
    (org-datetree-find-month-create (funcall date) 'subtree-at-point)))

(defun my-locator-olp-in (olp prev)
  "A locator to the specified olp OLP in PREV."
  (lambda ()
    (funcall prev)
    (let ((olp-pos (condition-case
                     (org-find-olp olp)
                    (error (error "Aborting template expansion: Cannot find OLP")))))
     (goto-char (org-find-olp olp t)))))

(defun my-locator-file (filename)
  "A locator to a new file in a new window."
  (lambda ()
    (when (string-blank-p filename)
      (error "FILENAME should not be blank"))
    (find-file-other-window filename)))

(defun my-capture-wrapper (feeder locator)
  "A general wrapper for capturing.

This function returns a function that calls FEEDER and put its return value to
the place specified by LOCATOR. Specifically, it calls LOCATOR first, which put
the point to the right place, and then use `org-paste-subtree' to put the entry
returned by FEEDER as a child of the current point."
  (lambda ()
    (interactive)
    (funcall locator)
    (org-paste-subtree (org-get-valid-level (org-current-level) (org-level-increment))
                       (funcall feeder) 'for-yank)))

(define-key global-map (kbd "C-c C p") (my-capture-wrapper #'my-feeder-oi-problem
                                        (my-locator-end-of-subtree
                                         (my-locator-monthly-datetree-in (lambda () (decode-time-mdy (org-current-time)))
                                          (my-locator-olp-in '("OI" "题目")
                                           (my-locator-file "~/org/todo.org"))))))

(add-hook 'org-mode-hook 'visual-line-mode)

(setopt org-capture-templates
        '(("p" "OI 题目" entry (file+olp+datetree "~/org/todo.org" "OI" "题目")
           "* 未提交 [#B] OI 题目 %(let* ((title (read-string \"题目在洛谷中的标题 [P1001 A+B Problem]\" nil nil \"P1001 A+B Problem\")) (link (replace-regexp-in-string \"\\\\([^ ]+\\\\) \\\\(.*\\\\)\" \"[[https://www.luogu.com.cn/problem/\\\\1][\\\\&]]\" \"P1001 A+B Problem\" t))) link)
:Created: %U
DEADLINE: %(org-read-date nil nil nil \"截止时间\" nil \"+3d\")
%?"
           :empty-lines 0)
          ("e" "OI 比赛" entry (file+olp+datetree "~/org/todo.org" "OI" "比赛")
           "* 未开始 [#B] OI 比赛 [[%^{比赛网址}][%^{比赛名}]]
:Created: %U
SCHEDULED: %(org-read-date t nil nil \"比赛开始时间\" nil \"+1w 14:00\")--%(org-read-date t nil nil \"比赛结束时间\" nil \"+1w 17:00\")
%?"
           :empty-lines 0)))

(setopt org-read-date-force-compatible-dates nil)

(setopt org-todo-keywords '((sequence "未开始" "进行中" "等待订正(!)" "|" "已订正(!@)") ; 比赛
                            (sequence "未提交" "UNAC(!@)" "AC(!)" "|" "已完成(!@)")     ; 题目
                            ))
(setopt org-todo-keyword-faces `(("未提交"   . (:foreground ,(plist-get base16-stylix-theme-colors :base09)))
                                 ("UNAC"     . (:foreground ,(plist-get base16-stylix-theme-colors :base08)))
                                 ("AC"       . (:foreground ,(plist-get base16-stylix-theme-colors :base0D)))
                                 ("已完成"   . (:foreground ,(plist-get base16-stylix-theme-colors :base0B)))
                                 ("未开始"   . (:foreground ,(plist-get base16-stylix-theme-colors :base05)))
                                 ("进行中"   . (:foreground ,(plist-get base16-stylix-theme-colors :base0D)))
                                 ("等待订正" . (:foreground ,(plist-get base16-stylix-theme-colors :base0A)))
                                 ("已订正"   . (:foreground ,(plist-get base16-stylix-theme-colors :base0B)))
                                 ))

(setopt org-agenda-time-grid '((daily today require-timed remove-match) (630 730 1200 1330 1800 1900 2200) " · " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))
(setopt org-agenda-prefix-format '((agenda . " %i %-12:c%?-8t% s")
                                   (todo   . " %i %-12:c")
                                   (tags   . " %i %-12:c")
                                   (search . " %i %-12:c")))
      '';
    }
    {
      programs.emacs.extraConfig = lib.mkBefore ";; -*- lexical-binding: t; -*-";
    }
  ]);
}

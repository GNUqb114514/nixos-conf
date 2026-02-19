{
  pkgs,
  lib,
  config,
  inputs,
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

(add-hook 'org-mode-hook 'visual-line-mode)

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
      '';
    }
    {
      programs.emacs.extraConfig = lib.mkBefore ";; -*- lexical-binding: t; -*-";
    }
    (ulib.use-packages [
      {
        name = "org-hold";
        package = epkgs: with epkgs; epkgs.trivialBuild {
          pname = "org-hold";
          version = "0.1.0";
          src = inputs.org-hold;
        };
        configPhase = ''(bind-key "C-c h o p" (org-hold-template
                         (lambda ()
                           (let* ((title (read-string "题目在洛谷中的标题（如 P1001 A+B Problem）："))
                                  (link (replace-regexp-in-string "\\([^ ]+\\)\\( .*\\)?" "[[https://www.luogu.com.cn/problem/\\1][\\&]]" title t))
                                  (deadline (org-read-date nil nil nil "截止时间" nil "+3d"))
                                  (creation (format-time-string "[%Y-%m-%d %a %H:%M]" (org-current-time))))
                             (format "* 未提交 [#B] OI 题目 %s\n:Created: %s\nDEADLINE: <%s>\n"
                                     link creation deadline)))
                         (org-hold-locator-end-of-subtree
                          (org-hold-locator-monthly-datetree-in
                           (lambda () (org-hold-decode-time-mdy (org-current-time)))
                           (org-hold-locator-olp-in
                            '("OI" "题目")
                            (org-hold-locator-file "~/org/todo.org"))))))
(bind-key "C-c h o c" (org-hold-template
                         (lambda ()
                           (let* ((title (read-string "比赛的标题："))
                                  (link (read-string "比赛网址："))
                                  (sched-start (org-read-date t t nil "比赛开始时间" nil "+3d"))
                                  (sched-end (org-read-date t nil nil "比赛结束时间" sched-start "++3h"))
                                  (creation (format-time-string "[%Y-%m-%d %a %H:%M]" (org-current-time))))
                             (format "* 未提交 [#B] OI 比赛 [[%s][%s]]\n:Created: %s\nSCHEDULED: %s--<%s>\n"
                                     link title creation (format-time-string "<%Y-%m-%d %a %H:%M>" sched-start) sched-end)))
                         (org-hold-locator-end-of-subtree
                          (org-hold-locator-monthly-datetree-in
                           (lambda () (org-hold-decode-time-mdy (org-current-time)))
                           (org-hold-locator-olp-in
                            '("OI" "比赛")
                            (org-hold-locator-file "~/org/todo.org"))))))'';
      }
    ])
  ]);
}

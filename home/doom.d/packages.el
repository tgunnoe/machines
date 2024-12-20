;; Copyright 2024 Google LLC
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! evil-escape :disable t)

(package! dotenv-mode)
(package! git-link)
(package! gumshoe)
(package! chatgpt-shell)
(package! just-mode)
(package! org-present)
;; Prevent this double-pin Magit bug:
;;   • <https://github.com/doomemacs/doomemacs/issues/7363#issuecomment-1696530746>
;;   • <https://github.com/magit/magit/issues/4994>
;;(unpin! git-commit)

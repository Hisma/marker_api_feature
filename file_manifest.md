# File Manifest

**Generated on:** 2025-05-27 01:25:22  
**Repository:** `open-webui`  
**Feature Branch:** `marker-api-content-extraction` (commit: e12a79c0e)  
**Base Branch:** `main`

## Copied Files

The following files were extracted from the feature branch and copied to `modified_files/`:

- **Modified:** `.github/ISSUE_TEMPLATE/bug_report.yaml` (7149 bytes)
- **Modified:** `CHANGELOG.md` (182691 bytes)
- **Modified:** `backend/open_webui/config.py` (90408 bytes)
- **Modified:** `backend/open_webui/env.py` (16602 bytes)
- **Modified:** `backend/open_webui/functions.py` (10441 bytes)
- **Modified:** `backend/open_webui/internal/wrappers.py` (2090 bytes)
- **Modified:** `backend/open_webui/main.py` (55315 bytes)
- **Modified:** `backend/open_webui/models/auths.py` (5127 bytes)
- **Modified:** `backend/open_webui/models/chats.py` (33221 bytes)
- **Modified:** `backend/open_webui/models/functions.py` (10441 bytes)
- **Modified:** `backend/open_webui/models/groups.py` (7241 bytes)
- **Added:** `backend/open_webui/retrieval/loaders/datalab_marker_loader.py` (8831 bytes)
- **Modified:** `backend/open_webui/retrieval/loaders/main.py` (12525 bytes)
- **Modified:** `backend/open_webui/retrieval/loaders/mistral.py` (23386 bytes)
- **Added:** `backend/open_webui/retrieval/models/base_reranker.py` (219 bytes)
- **Modified:** `backend/open_webui/retrieval/models/colbert.py` (3486 bytes)
- **Modified:** `backend/open_webui/retrieval/models/external.py` (1754 bytes)
- **Modified:** `backend/open_webui/retrieval/utils.py` (28347 bytes)
- **Modified:** `backend/open_webui/retrieval/vector/dbs/pinecone.py` (18771 bytes)
- **Modified:** `backend/open_webui/retrieval/web/searchapi.py` (1384 bytes)
- **Modified:** `backend/open_webui/retrieval/web/serpapi.py` (1366 bytes)
- **Modified:** `backend/open_webui/retrieval/web/utils.py` (26470 bytes)
- **Modified:** `backend/open_webui/routers/audio.py` (39929 bytes)
- **Modified:** `backend/open_webui/routers/auths.py` (34230 bytes)
- **Modified:** `backend/open_webui/routers/chats.py` (24789 bytes)
- **Modified:** `backend/open_webui/routers/files.py` (19030 bytes)
- **Modified:** `backend/open_webui/routers/functions.py` (15511 bytes)
- **Modified:** `backend/open_webui/routers/images.py` (25090 bytes)
- **Modified:** `backend/open_webui/routers/ollama.py` (57728 bytes)
- **Modified:** `backend/open_webui/routers/retrieval.py` (87141 bytes)
- **Modified:** `backend/open_webui/routers/tools.py` (14756 bytes)
- **Modified:** `backend/open_webui/storage/provider.py` (14307 bytes)
- **Modified:** `backend/open_webui/utils/chat.py` (14535 bytes)
- **Modified:** `backend/open_webui/utils/filter.py` (4307 bytes)
- **Modified:** `backend/open_webui/utils/middleware.py` (97617 bytes)
- **Modified:** `backend/open_webui/utils/misc.py` (14177 bytes)
- **Modified:** `backend/open_webui/utils/models.py` (10676 bytes)
- **Modified:** `backend/open_webui/utils/oauth.py` (24380 bytes)
- **Modified:** `backend/open_webui/utils/payload.py` (9592 bytes)
- **Modified:** `backend/open_webui/utils/task.py` (11087 bytes)
- **Modified:** `backend/open_webui/utils/tools.py` (22917 bytes)
- **Modified:** `backend/requirements.txt` (2416 bytes)
- **Modified:** `package-lock.json` (445453 bytes)
- **Modified:** `package.json` (4401 bytes)
- **Modified:** `pyproject.toml` (4126 bytes)
- **Modified:** `src/app.css` (9570 bytes)
- **Modified:** `src/lib/apis/audio/index.ts` (3574 bytes)
- **Modified:** `src/lib/apis/chats/index.ts` (20599 bytes)
- **Modified:** `src/lib/apis/files/index.ts` (4559 bytes)
- **Modified:** `src/lib/apis/functions/index.ts` (9091 bytes)
- **Modified:** `src/lib/apis/index.ts` (33081 bytes)
- **Modified:** `src/lib/apis/ollama/index.ts` (11553 bytes)
- **Modified:** `src/lib/components/AddServerModal.svelte` (11205 bytes)
- **Modified:** `src/lib/components/admin/Functions.svelte` (18301 bytes)
- **Added:** `src/lib/components/admin/Functions/AddFunctionMenu.svelte` (2327 bytes)
- **Added:** `src/lib/components/admin/Functions/ImportModal.svelte` (4014 bytes)
- **Modified:** `src/lib/components/admin/Settings/Documents.svelte` (39044 bytes)
- **Modified:** `src/lib/components/admin/Settings/General.svelte` (22892 bytes)
- **Modified:** `src/lib/components/admin/Settings/Interface.svelte` (19331 bytes)
- **Added:** `src/lib/components/admin/Settings/Interface/Banners.svelte` (2923 bytes)
- **Modified:** `src/lib/components/admin/Settings/Models.svelte` (16106 bytes)
- **Modified:** `src/lib/components/admin/Settings/Models/ModelMenu.svelte` (3961 bytes)
- **Modified:** `src/lib/components/admin/Settings/WebSearch.svelte` (27740 bytes)
- **Modified:** `src/lib/components/admin/Users/UserList.svelte` (16273 bytes)
- **Modified:** `src/lib/components/admin/Users/UserList/UserChatsModal.svelte` (2603 bytes)
- **Modified:** `src/lib/components/channel/MessageInput.svelte` (17581 bytes)
- **Modified:** `src/lib/components/channel/Navbar.svelte` (2452 bytes)
- **Modified:** `src/lib/components/chat/Chat.svelte` (58563 bytes)
- **Modified:** `src/lib/components/chat/ContentRenderer/FloatingButtons.svelte` (8997 bytes)
- **Modified:** `src/lib/components/chat/MessageInput.svelte` (52922 bytes)
- **Modified:** `src/lib/components/chat/MessageInput/CallOverlay.svelte` (26841 bytes)
- **Modified:** `src/lib/components/chat/MessageInput/VoiceRecording.svelte` (14392 bytes)
- **Modified:** `src/lib/components/chat/Messages/CitationsModal.svelte` (6425 bytes)
- **Modified:** `src/lib/components/chat/Messages/Markdown/AlertRenderer.svelte` (2716 bytes)
- **Modified:** `src/lib/components/chat/Messages/ResponseMessage.svelte` (45525 bytes)
- **Modified:** `src/lib/components/chat/ModelSelector/Selector.svelte` (26930 bytes)
- **Modified:** `src/lib/components/chat/Navbar.svelte` (7085 bytes)
- **Modified:** `src/lib/components/chat/Placeholder.svelte` (6985 bytes)
- **Modified:** `src/lib/components/chat/Settings/Advanced/AdvancedParams.svelte` (39488 bytes)
- **Modified:** `src/lib/components/chat/Settings/Audio.svelte` (11875 bytes)
- **Modified:** `src/lib/components/chat/Settings/Chats.svelte` (11702 bytes)
- **Modified:** `src/lib/components/chat/Settings/Personalization/AddMemoryModal.svelte` (3498 bytes)
- **Modified:** `src/lib/components/chat/Settings/Personalization/EditMemoryModal.svelte` (3612 bytes)
- **Modified:** `src/lib/components/chat/Suggestions.svelte` (3852 bytes)
- **Modified:** `src/lib/components/common/RichTextInput.svelte` (12093 bytes)
- **Added:** `src/lib/components/icons/Github.svelte` (1127 bytes)
- **Added:** `src/lib/components/layout/ArchivedChatsModal.svelte` (4052 bytes)
- **Added:** `src/lib/components/layout/ChatsModal.svelte` (14574 bytes)
- **Modified:** `src/lib/components/layout/Navbar.svelte` (5810 bytes)
- **Modified:** `src/lib/components/layout/SearchModal.svelte` (5362 bytes)
- **Modified:** `src/lib/components/layout/Sidebar.svelte` (25561 bytes)
- **Modified:** `src/lib/components/layout/Sidebar/SearchInput.svelte` (6703 bytes)
- **Modified:** `src/lib/components/layout/Sidebar/UserMenu.svelte` (9295 bytes)
- **Modified:** `src/lib/components/notes/NoteEditor.svelte` (26428 bytes)
- **Modified:** `src/lib/components/notes/RecordMenu.svelte` (2382 bytes)
- **Modified:** `src/lib/components/workspace/Knowledge.svelte` (6099 bytes)
- **Modified:** `src/lib/components/workspace/Knowledge/KnowledgeBase.svelte` (24889 bytes)
- **Modified:** `src/lib/components/workspace/Models.svelte` (16706 bytes)
- **Modified:** `src/lib/components/workspace/Models/ModelMenu.svelte` (5167 bytes)
- **Modified:** `src/lib/i18n/locales/ar-BH/translation.json` (64308 bytes)
- **Modified:** `src/lib/i18n/locales/ar/translation.json` (100606 bytes)
- **Modified:** `src/lib/i18n/locales/bg-BG/translation.json` (108907 bytes)
- **Modified:** `src/lib/i18n/locales/bn-BD/translation.json` (73780 bytes)
- **Modified:** `src/lib/i18n/locales/bo-TB/translation.json` (156778 bytes)
- **Modified:** `src/lib/i18n/locales/ca-ES/translation.json` (93541 bytes)
- **Modified:** `src/lib/i18n/locales/ceb-PH/translation.json` (55325 bytes)
- **Modified:** `src/lib/i18n/locales/cs-CZ/translation.json` (72879 bytes)
- **Modified:** `src/lib/i18n/locales/da-DK/translation.json` (75542 bytes)
- **Modified:** `src/lib/i18n/locales/de-DE/translation.json` (93752 bytes)
- **Modified:** `src/lib/i18n/locales/dg-DG/translation.json` (55294 bytes)
- **Modified:** `src/lib/i18n/locales/el-GR/translation.json` (102846 bytes)
- **Modified:** `src/lib/i18n/locales/en-GB/translation.json` (49427 bytes)
- **Modified:** `src/lib/i18n/locales/en-US/translation.json` (49427 bytes)
- **Modified:** `src/lib/i18n/locales/es-ES/translation.json` (91626 bytes)
- **Modified:** `src/lib/i18n/locales/et-EE/translation.json` (83684 bytes)
- **Modified:** `src/lib/i18n/locales/eu-ES/translation.json` (76797 bytes)
- **Modified:** `src/lib/i18n/locales/fa-IR/translation.json` (111187 bytes)
- **Modified:** `src/lib/i18n/locales/fi-FI/translation.json` (89585 bytes)
- **Modified:** `src/lib/i18n/locales/fr-CA/translation.json` (66808 bytes)
- **Modified:** `src/lib/i18n/locales/fr-FR/translation.json` (91751 bytes)
- **Modified:** `src/lib/i18n/locales/he-IL/translation.json` (61977 bytes)
- **Modified:** `src/lib/i18n/locales/hi-IN/translation.json` (73206 bytes)
- **Modified:** `src/lib/i18n/locales/hr-HR/translation.json` (60387 bytes)
- **Modified:** `src/lib/i18n/locales/hu-HU/translation.json` (91685 bytes)
- **Modified:** `src/lib/i18n/locales/id-ID/translation.json` (62911 bytes)
- **Modified:** `src/lib/i18n/locales/ie-GA/translation.json` (92737 bytes)
- **Modified:** `src/lib/i18n/locales/it-IT/translation.json` (92719 bytes)
- **Modified:** `src/lib/i18n/locales/ja-JP/translation.json` (93918 bytes)
- **Modified:** `src/lib/i18n/locales/ka-GE/translation.json` (85378 bytes)
- **Modified:** `src/lib/i18n/locales/ko-KR/translation.json` (93158 bytes)
- **Modified:** `src/lib/i18n/locales/lt-LT/translation.json` (63703 bytes)
- **Modified:** `src/lib/i18n/locales/ms-MY/translation.json` (64617 bytes)
- **Modified:** `src/lib/i18n/locales/nb-NO/translation.json` (80032 bytes)
- **Modified:** `src/lib/i18n/locales/nl-NL/translation.json` (86681 bytes)
- **Modified:** `src/lib/i18n/locales/pa-IN/translation.json` (71917 bytes)
- **Modified:** `src/lib/i18n/locales/pl-PL/translation.json` (84921 bytes)
- **Modified:** `src/lib/i18n/locales/pt-BR/translation.json` (77694 bytes)
- **Modified:** `src/lib/i18n/locales/pt-PT/translation.json` (61681 bytes)
- **Modified:** `src/lib/i18n/locales/ro-RO/translation.json` (75165 bytes)
- **Modified:** `src/lib/i18n/locales/ru-RU/translation.json` (129237 bytes)
- **Modified:** `src/lib/i18n/locales/sk-SK/translation.json` (73088 bytes)
- **Modified:** `src/lib/i18n/locales/sr-RS/translation.json` (76185 bytes)
- **Modified:** `src/lib/i18n/locales/sv-SE/translation.json` (65307 bytes)
- **Modified:** `src/lib/i18n/locales/th-TH/translation.json` (85144 bytes)
- **Modified:** `src/lib/i18n/locales/tk-TW/translation.json` (49447 bytes)
- **Modified:** `src/lib/i18n/locales/tr-TR/translation.json` (79286 bytes)
- **Modified:** `src/lib/i18n/locales/uk-UA/translation.json` (115881 bytes)
- **Modified:** `src/lib/i18n/locales/ur-PK/translation.json` (84738 bytes)
- **Modified:** `src/lib/i18n/locales/vi-VN/translation.json` (96234 bytes)
- **Modified:** `src/lib/i18n/locales/zh-CN/translation.json` (84916 bytes)
- **Modified:** `src/lib/i18n/locales/zh-TW/translation.json` (84974 bytes)
- **Modified:** `src/lib/utils/index.ts` (39618 bytes)
- **Modified:** `src/lib/utils/marked/katex-extension.ts` (4538 bytes)
- **Modified:** `src/routes/(app)/+page.svelte` (93 bytes)
- **Modified:** `src/routes/(app)/c/[id]/+page.svelte` (160 bytes)
- **Modified:** `src/routes/(app)/notes/+layout.svelte` (2841 bytes)
- **Modified:** `src/routes/+layout.svelte` (17953 bytes)

## Failed Copies

The following files could not be copied:

- **:** `` (extraction failed)

## Directory Structure

```
modified_files/
  ./backend/open_webui/config.py
  ./backend/open_webui/env.py
  ./backend/open_webui/functions.py
  ./backend/open_webui/internal/wrappers.py
  ./backend/open_webui/main.py
  ./backend/open_webui/models/auths.py
  ./backend/open_webui/models/chats.py
  ./backend/open_webui/models/functions.py
  ./backend/open_webui/models/groups.py
  ./backend/open_webui/retrieval/loaders/datalab_marker_loader.py
  ./backend/open_webui/retrieval/loaders/main.py
  ./backend/open_webui/retrieval/loaders/mistral.py
  ./backend/open_webui/retrieval/models/base_reranker.py
  ./backend/open_webui/retrieval/models/colbert.py
  ./backend/open_webui/retrieval/models/external.py
  ./backend/open_webui/retrieval/utils.py
  ./backend/open_webui/retrieval/vector/dbs/pinecone.py
  ./backend/open_webui/retrieval/web/searchapi.py
  ./backend/open_webui/retrieval/web/serpapi.py
  ./backend/open_webui/retrieval/web/utils.py
  ./backend/open_webui/routers/audio.py
  ./backend/open_webui/routers/auths.py
  ./backend/open_webui/routers/chats.py
  ./backend/open_webui/routers/files.py
  ./backend/open_webui/routers/functions.py
  ./backend/open_webui/routers/images.py
  ./backend/open_webui/routers/ollama.py
  ./backend/open_webui/routers/retrieval.py
  ./backend/open_webui/routers/tools.py
  ./backend/open_webui/storage/provider.py
  ./backend/open_webui/utils/chat.py
  ./backend/open_webui/utils/filter.py
  ./backend/open_webui/utils/middleware.py
  ./backend/open_webui/utils/misc.py
  ./backend/open_webui/utils/models.py
  ./backend/open_webui/utils/oauth.py
  ./backend/open_webui/utils/payload.py
  ./backend/open_webui/utils/task.py
  ./backend/open_webui/utils/tools.py
  ./backend/requirements.txt
  ./CHANGELOG.md
  ./.github/ISSUE_TEMPLATE/bug_report.yaml
  ./package.json
  ./package-lock.json
  ./pyproject.toml
  ./src/app.css
  ./src/lib/apis/audio/index.ts
  ./src/lib/apis/chats/index.ts
  ./src/lib/apis/files/index.ts
  ./src/lib/apis/functions/index.ts
  ./src/lib/apis/index.ts
  ./src/lib/apis/ollama/index.ts
  ./src/lib/components/AddServerModal.svelte
  ./src/lib/components/admin/Functions/AddFunctionMenu.svelte
  ./src/lib/components/admin/Functions/ImportModal.svelte
  ./src/lib/components/admin/Functions.svelte
  ./src/lib/components/admin/Settings/Documents.svelte
  ./src/lib/components/admin/Settings/General.svelte
  ./src/lib/components/admin/Settings/Interface/Banners.svelte
  ./src/lib/components/admin/Settings/Interface.svelte
  ./src/lib/components/admin/Settings/Models/ModelMenu.svelte
  ./src/lib/components/admin/Settings/Models.svelte
  ./src/lib/components/admin/Settings/WebSearch.svelte
  ./src/lib/components/admin/Users/UserList.svelte
  ./src/lib/components/admin/Users/UserList/UserChatsModal.svelte
  ./src/lib/components/channel/MessageInput.svelte
  ./src/lib/components/channel/Navbar.svelte
  ./src/lib/components/chat/Chat.svelte
  ./src/lib/components/chat/ContentRenderer/FloatingButtons.svelte
  ./src/lib/components/chat/MessageInput/CallOverlay.svelte
  ./src/lib/components/chat/MessageInput.svelte
  ./src/lib/components/chat/MessageInput/VoiceRecording.svelte
  ./src/lib/components/chat/Messages/CitationsModal.svelte
  ./src/lib/components/chat/Messages/Markdown/AlertRenderer.svelte
  ./src/lib/components/chat/Messages/ResponseMessage.svelte
  ./src/lib/components/chat/ModelSelector/Selector.svelte
  ./src/lib/components/chat/Navbar.svelte
  ./src/lib/components/chat/Placeholder.svelte
  ./src/lib/components/chat/Settings/Advanced/AdvancedParams.svelte
  ./src/lib/components/chat/Settings/Audio.svelte
  ./src/lib/components/chat/Settings/Chats.svelte
  ./src/lib/components/chat/Settings/Personalization/AddMemoryModal.svelte
  ./src/lib/components/chat/Settings/Personalization/EditMemoryModal.svelte
  ./src/lib/components/chat/Suggestions.svelte
  ./src/lib/components/common/RichTextInput.svelte
  ./src/lib/components/icons/Github.svelte
  ./src/lib/components/layout/ArchivedChatsModal.svelte
  ./src/lib/components/layout/ChatsModal.svelte
  ./src/lib/components/layout/Navbar.svelte
  ./src/lib/components/layout/SearchModal.svelte
  ./src/lib/components/layout/Sidebar/SearchInput.svelte
  ./src/lib/components/layout/Sidebar.svelte
  ./src/lib/components/layout/Sidebar/UserMenu.svelte
  ./src/lib/components/notes/NoteEditor.svelte
  ./src/lib/components/notes/RecordMenu.svelte
  ./src/lib/components/workspace/Knowledge/KnowledgeBase.svelte
  ./src/lib/components/workspace/Knowledge.svelte
  ./src/lib/components/workspace/Models/ModelMenu.svelte
  ./src/lib/components/workspace/Models.svelte
  ./src/lib/i18n/locales/ar-BH/translation.json
  ./src/lib/i18n/locales/ar/translation.json
  ./src/lib/i18n/locales/bg-BG/translation.json
  ./src/lib/i18n/locales/bn-BD/translation.json
  ./src/lib/i18n/locales/bo-TB/translation.json
  ./src/lib/i18n/locales/ca-ES/translation.json
  ./src/lib/i18n/locales/ceb-PH/translation.json
  ./src/lib/i18n/locales/cs-CZ/translation.json
  ./src/lib/i18n/locales/da-DK/translation.json
  ./src/lib/i18n/locales/de-DE/translation.json
  ./src/lib/i18n/locales/dg-DG/translation.json
  ./src/lib/i18n/locales/el-GR/translation.json
  ./src/lib/i18n/locales/en-GB/translation.json
  ./src/lib/i18n/locales/en-US/translation.json
  ./src/lib/i18n/locales/es-ES/translation.json
  ./src/lib/i18n/locales/et-EE/translation.json
  ./src/lib/i18n/locales/eu-ES/translation.json
  ./src/lib/i18n/locales/fa-IR/translation.json
  ./src/lib/i18n/locales/fi-FI/translation.json
  ./src/lib/i18n/locales/fr-CA/translation.json
  ./src/lib/i18n/locales/fr-FR/translation.json
  ./src/lib/i18n/locales/he-IL/translation.json
  ./src/lib/i18n/locales/hi-IN/translation.json
  ./src/lib/i18n/locales/hr-HR/translation.json
  ./src/lib/i18n/locales/hu-HU/translation.json
  ./src/lib/i18n/locales/id-ID/translation.json
  ./src/lib/i18n/locales/ie-GA/translation.json
  ./src/lib/i18n/locales/it-IT/translation.json
  ./src/lib/i18n/locales/ja-JP/translation.json
  ./src/lib/i18n/locales/ka-GE/translation.json
  ./src/lib/i18n/locales/ko-KR/translation.json
  ./src/lib/i18n/locales/lt-LT/translation.json
  ./src/lib/i18n/locales/ms-MY/translation.json
  ./src/lib/i18n/locales/nb-NO/translation.json
  ./src/lib/i18n/locales/nl-NL/translation.json
  ./src/lib/i18n/locales/pa-IN/translation.json
  ./src/lib/i18n/locales/pl-PL/translation.json
  ./src/lib/i18n/locales/pt-BR/translation.json
  ./src/lib/i18n/locales/pt-PT/translation.json
  ./src/lib/i18n/locales/ro-RO/translation.json
  ./src/lib/i18n/locales/ru-RU/translation.json
  ./src/lib/i18n/locales/sk-SK/translation.json
  ./src/lib/i18n/locales/sr-RS/translation.json
  ./src/lib/i18n/locales/sv-SE/translation.json
  ./src/lib/i18n/locales/th-TH/translation.json
  ./src/lib/i18n/locales/tk-TW/translation.json
  ./src/lib/i18n/locales/tr-TR/translation.json
  ./src/lib/i18n/locales/uk-UA/translation.json
  ./src/lib/i18n/locales/ur-PK/translation.json
  ./src/lib/i18n/locales/vi-VN/translation.json
  ./src/lib/i18n/locales/zh-CN/translation.json
  ./src/lib/i18n/locales/zh-TW/translation.json
  ./src/lib/utils/index.ts
  ./src/lib/utils/marked/katex-extension.ts
  ./src/routes/(app)/c/[id]/+page.svelte
  ./src/routes/(app)/notes/+layout.svelte
  ./src/routes/(app)/+page.svelte
  ./src/routes/+layout.svelte
```

---

*Generated by enhanced implementation guide script on 2025-05-27 01:25:22*

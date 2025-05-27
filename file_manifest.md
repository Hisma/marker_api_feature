# File Manifest

**Generated on:** 2025-05-27 02:03:05  
**Repository:** `open-webui`  
**Feature Branch:** `marker-api-content-extraction`  
**Base Branch:**    `main`  
**Merge-Base:**     `82716f3789147585862f56f9f18fb2a77d92ed39`

## Copied Files
- **M**: `.github/ISSUE_TEMPLATE/bug_report.yaml` (7149 bytes)
- **M**: `CHANGELOG.md` (182691 bytes)
- **M**: `backend/open_webui/config.py` (90408 bytes)
- **M**: `backend/open_webui/env.py` (16602 bytes)
- **M**: `backend/open_webui/functions.py` (10441 bytes)
- **M**: `backend/open_webui/internal/wrappers.py` (2090 bytes)
- **M**: `backend/open_webui/main.py` (55315 bytes)
- **M**: `backend/open_webui/models/auths.py` (5127 bytes)
- **M**: `backend/open_webui/models/chats.py` (33221 bytes)
- **M**: `backend/open_webui/models/functions.py` (10441 bytes)
- **M**: `backend/open_webui/models/groups.py` (7241 bytes)
- **A**: `backend/open_webui/retrieval/loaders/datalab_marker_loader.py` (8831 bytes)
- **M**: `backend/open_webui/retrieval/loaders/main.py` (12525 bytes)
- **M**: `backend/open_webui/retrieval/loaders/mistral.py` (23386 bytes)
- **A**: `backend/open_webui/retrieval/models/base_reranker.py` (219 bytes)
- **M**: `backend/open_webui/retrieval/models/colbert.py` (3486 bytes)
- **M**: `backend/open_webui/retrieval/models/external.py` (1754 bytes)
- **M**: `backend/open_webui/retrieval/utils.py` (28347 bytes)
- **M**: `backend/open_webui/retrieval/vector/dbs/pinecone.py` (18771 bytes)
- **M**: `backend/open_webui/retrieval/web/searchapi.py` (1384 bytes)
- **M**: `backend/open_webui/retrieval/web/serpapi.py` (1366 bytes)
- **M**: `backend/open_webui/retrieval/web/utils.py` (26470 bytes)
- **M**: `backend/open_webui/routers/audio.py` (39929 bytes)
- **M**: `backend/open_webui/routers/auths.py` (34230 bytes)
- **M**: `backend/open_webui/routers/chats.py` (24789 bytes)
- **M**: `backend/open_webui/routers/files.py` (19030 bytes)
- **M**: `backend/open_webui/routers/functions.py` (15511 bytes)
- **M**: `backend/open_webui/routers/images.py` (25090 bytes)
- **M**: `backend/open_webui/routers/ollama.py` (57728 bytes)
- **M**: `backend/open_webui/routers/retrieval.py` (87141 bytes)
- **M**: `backend/open_webui/routers/tools.py` (14756 bytes)
- **M**: `backend/open_webui/storage/provider.py` (14307 bytes)
- **M**: `backend/open_webui/utils/chat.py` (14535 bytes)
- **M**: `backend/open_webui/utils/filter.py` (4307 bytes)
- **M**: `backend/open_webui/utils/middleware.py` (97617 bytes)
- **M**: `backend/open_webui/utils/misc.py` (14177 bytes)
- **M**: `backend/open_webui/utils/models.py` (10676 bytes)
- **M**: `backend/open_webui/utils/oauth.py` (24380 bytes)
- **M**: `backend/open_webui/utils/payload.py` (9592 bytes)
- **M**: `backend/open_webui/utils/task.py` (11087 bytes)
- **M**: `backend/open_webui/utils/tools.py` (22917 bytes)
- **M**: `backend/requirements.txt` (2416 bytes)
- **M**: `package-lock.json` (445453 bytes)
- **M**: `package.json` (4401 bytes)
- **M**: `pyproject.toml` (4126 bytes)
- **M**: `src/app.css` (9570 bytes)
- **M**: `src/lib/apis/audio/index.ts` (3574 bytes)
- **M**: `src/lib/apis/chats/index.ts` (20599 bytes)
- **M**: `src/lib/apis/files/index.ts` (4559 bytes)
- **M**: `src/lib/apis/functions/index.ts` (9091 bytes)
- **M**: `src/lib/apis/index.ts` (33081 bytes)
- **M**: `src/lib/apis/ollama/index.ts` (11553 bytes)
- **M**: `src/lib/components/AddServerModal.svelte` (11205 bytes)
- **M**: `src/lib/components/admin/Functions.svelte` (18301 bytes)
- **A**: `src/lib/components/admin/Functions/AddFunctionMenu.svelte` (2327 bytes)
- **A**: `src/lib/components/admin/Functions/ImportModal.svelte` (4014 bytes)
- **M**: `src/lib/components/admin/Settings/Documents.svelte` (39044 bytes)
- **M**: `src/lib/components/admin/Settings/General.svelte` (22892 bytes)
- **M**: `src/lib/components/admin/Settings/Interface.svelte` (19331 bytes)
- **A**: `src/lib/components/admin/Settings/Interface/Banners.svelte` (2923 bytes)
- **M**: `src/lib/components/admin/Settings/Models.svelte` (16106 bytes)
- **M**: `src/lib/components/admin/Settings/Models/ModelMenu.svelte` (3961 bytes)
- **M**: `src/lib/components/admin/Settings/WebSearch.svelte` (27740 bytes)
- **M**: `src/lib/components/admin/Users/UserList.svelte` (16273 bytes)
- **M**: `src/lib/components/admin/Users/UserList/UserChatsModal.svelte` (2603 bytes)
- **M**: `src/lib/components/channel/MessageInput.svelte` (17581 bytes)
- **M**: `src/lib/components/channel/Navbar.svelte` (2452 bytes)
- **M**: `src/lib/components/chat/Chat.svelte` (58563 bytes)
- **M**: `src/lib/components/chat/ContentRenderer/FloatingButtons.svelte` (8997 bytes)
- **M**: `src/lib/components/chat/MessageInput.svelte` (52922 bytes)
- **M**: `src/lib/components/chat/MessageInput/CallOverlay.svelte` (26841 bytes)
- **M**: `src/lib/components/chat/MessageInput/VoiceRecording.svelte` (14392 bytes)
- **M**: `src/lib/components/chat/Messages/CitationsModal.svelte` (6425 bytes)
- **M**: `src/lib/components/chat/Messages/Markdown/AlertRenderer.svelte` (2716 bytes)
- **M**: `src/lib/components/chat/Messages/ResponseMessage.svelte` (45525 bytes)
- **M**: `src/lib/components/chat/ModelSelector/Selector.svelte` (26930 bytes)
- **M**: `src/lib/components/chat/Navbar.svelte` (7085 bytes)
- **M**: `src/lib/components/chat/Placeholder.svelte` (6985 bytes)
- **M**: `src/lib/components/chat/Settings/Advanced/AdvancedParams.svelte` (39488 bytes)
- **M**: `src/lib/components/chat/Settings/Audio.svelte` (11875 bytes)
- **M**: `src/lib/components/chat/Settings/Chats.svelte` (11702 bytes)
- **M**: `src/lib/components/chat/Settings/Personalization/AddMemoryModal.svelte` (3498 bytes)
- **M**: `src/lib/components/chat/Settings/Personalization/EditMemoryModal.svelte` (3612 bytes)
- **M**: `src/lib/components/chat/Suggestions.svelte` (3852 bytes)
- **M**: `src/lib/components/common/RichTextInput.svelte` (12093 bytes)
- **A**: `src/lib/components/icons/Github.svelte` (1127 bytes)
- **A**: `src/lib/components/layout/ArchivedChatsModal.svelte` (4052 bytes)
- **A**: `src/lib/components/layout/ChatsModal.svelte` (14574 bytes)
- **M**: `src/lib/components/layout/Navbar.svelte` (5810 bytes)
- **M**: `src/lib/components/layout/SearchModal.svelte` (5362 bytes)
- **M**: `src/lib/components/layout/Sidebar.svelte` (25561 bytes)
- **M**: `src/lib/components/layout/Sidebar/SearchInput.svelte` (6703 bytes)
- **M**: `src/lib/components/layout/Sidebar/UserMenu.svelte` (9295 bytes)
- **M**: `src/lib/components/notes/NoteEditor.svelte` (26428 bytes)
- **M**: `src/lib/components/notes/RecordMenu.svelte` (2382 bytes)
- **M**: `src/lib/components/workspace/Knowledge.svelte` (6099 bytes)
- **M**: `src/lib/components/workspace/Knowledge/KnowledgeBase.svelte` (24889 bytes)
- **M**: `src/lib/components/workspace/Models.svelte` (16706 bytes)
- **M**: `src/lib/components/workspace/Models/ModelMenu.svelte` (5167 bytes)
- **M**: `src/lib/i18n/locales/ar-BH/translation.json` (64308 bytes)
- **M**: `src/lib/i18n/locales/ar/translation.json` (100606 bytes)
- **M**: `src/lib/i18n/locales/bg-BG/translation.json` (108907 bytes)
- **M**: `src/lib/i18n/locales/bn-BD/translation.json` (73780 bytes)
- **M**: `src/lib/i18n/locales/bo-TB/translation.json` (156778 bytes)
- **M**: `src/lib/i18n/locales/ca-ES/translation.json` (93541 bytes)
- **M**: `src/lib/i18n/locales/ceb-PH/translation.json` (55325 bytes)
- **M**: `src/lib/i18n/locales/cs-CZ/translation.json` (72879 bytes)
- **M**: `src/lib/i18n/locales/da-DK/translation.json` (75542 bytes)
- **M**: `src/lib/i18n/locales/de-DE/translation.json` (93752 bytes)
- **M**: `src/lib/i18n/locales/dg-DG/translation.json` (55294 bytes)
- **M**: `src/lib/i18n/locales/el-GR/translation.json` (102846 bytes)
- **M**: `src/lib/i18n/locales/en-GB/translation.json` (49427 bytes)
- **M**: `src/lib/i18n/locales/en-US/translation.json` (49427 bytes)
- **M**: `src/lib/i18n/locales/es-ES/translation.json` (91626 bytes)
- **M**: `src/lib/i18n/locales/et-EE/translation.json` (83684 bytes)
- **M**: `src/lib/i18n/locales/eu-ES/translation.json` (76797 bytes)
- **M**: `src/lib/i18n/locales/fa-IR/translation.json` (111187 bytes)
- **M**: `src/lib/i18n/locales/fi-FI/translation.json` (89585 bytes)
- **M**: `src/lib/i18n/locales/fr-CA/translation.json` (66808 bytes)
- **M**: `src/lib/i18n/locales/fr-FR/translation.json` (91751 bytes)
- **M**: `src/lib/i18n/locales/he-IL/translation.json` (61977 bytes)
- **M**: `src/lib/i18n/locales/hi-IN/translation.json` (73206 bytes)
- **M**: `src/lib/i18n/locales/hr-HR/translation.json` (60387 bytes)
- **M**: `src/lib/i18n/locales/hu-HU/translation.json` (91685 bytes)
- **M**: `src/lib/i18n/locales/id-ID/translation.json` (62911 bytes)
- **M**: `src/lib/i18n/locales/ie-GA/translation.json` (92737 bytes)
- **M**: `src/lib/i18n/locales/it-IT/translation.json` (92719 bytes)
- **M**: `src/lib/i18n/locales/ja-JP/translation.json` (93918 bytes)
- **M**: `src/lib/i18n/locales/ka-GE/translation.json` (85378 bytes)
- **M**: `src/lib/i18n/locales/ko-KR/translation.json` (93158 bytes)
- **M**: `src/lib/i18n/locales/lt-LT/translation.json` (63703 bytes)
- **M**: `src/lib/i18n/locales/ms-MY/translation.json` (64617 bytes)
- **M**: `src/lib/i18n/locales/nb-NO/translation.json` (80032 bytes)
- **M**: `src/lib/i18n/locales/nl-NL/translation.json` (86681 bytes)
- **M**: `src/lib/i18n/locales/pa-IN/translation.json` (71917 bytes)
- **M**: `src/lib/i18n/locales/pl-PL/translation.json` (84921 bytes)
- **M**: `src/lib/i18n/locales/pt-BR/translation.json` (77694 bytes)
- **M**: `src/lib/i18n/locales/pt-PT/translation.json` (61681 bytes)
- **M**: `src/lib/i18n/locales/ro-RO/translation.json` (75165 bytes)
- **M**: `src/lib/i18n/locales/ru-RU/translation.json` (129237 bytes)
- **M**: `src/lib/i18n/locales/sk-SK/translation.json` (73088 bytes)
- **M**: `src/lib/i18n/locales/sr-RS/translation.json` (76185 bytes)
- **M**: `src/lib/i18n/locales/sv-SE/translation.json` (65307 bytes)
- **M**: `src/lib/i18n/locales/th-TH/translation.json` (85144 bytes)
- **M**: `src/lib/i18n/locales/tk-TW/translation.json` (49447 bytes)
- **M**: `src/lib/i18n/locales/tr-TR/translation.json` (79286 bytes)
- **M**: `src/lib/i18n/locales/uk-UA/translation.json` (115881 bytes)
- **M**: `src/lib/i18n/locales/ur-PK/translation.json` (84738 bytes)
- **M**: `src/lib/i18n/locales/vi-VN/translation.json` (96234 bytes)
- **M**: `src/lib/i18n/locales/zh-CN/translation.json` (84916 bytes)
- **M**: `src/lib/i18n/locales/zh-TW/translation.json` (84974 bytes)
- **M**: `src/lib/utils/index.ts` (39618 bytes)
- **M**: `src/lib/utils/marked/katex-extension.ts` (4538 bytes)
- **M**: `src/routes/(app)/+page.svelte` (93 bytes)
- **M**: `src/routes/(app)/c/[id]/+page.svelte` (160 bytes)
- **M**: `src/routes/(app)/notes/+layout.svelte` (2841 bytes)
- **M**: `src/routes/+layout.svelte` (17953 bytes)

## Failed Copies
- ****: `` (failed)

## Directory Structure

```
  ./package.json
  ./backend/requirements.txt
  ./backend/open_webui/retrieval/web/searchapi.py
  ./backend/open_webui/retrieval/web/serpapi.py
  ./backend/open_webui/retrieval/web/utils.py
  ./backend/open_webui/retrieval/vector/dbs/pinecone.py
  ./backend/open_webui/retrieval/utils.py
  ./backend/open_webui/retrieval/loaders/datalab_marker_loader.py
  ./backend/open_webui/retrieval/loaders/main.py
  ./backend/open_webui/retrieval/loaders/mistral.py
  ./backend/open_webui/retrieval/models/external.py
  ./backend/open_webui/retrieval/models/base_reranker.py
  ./backend/open_webui/retrieval/models/colbert.py
  ./backend/open_webui/utils/tools.py
  ./backend/open_webui/utils/filter.py
  ./backend/open_webui/utils/payload.py
  ./backend/open_webui/utils/models.py
  ./backend/open_webui/utils/oauth.py
  ./backend/open_webui/utils/misc.py
  ./backend/open_webui/utils/chat.py
  ./backend/open_webui/utils/middleware.py
  ./backend/open_webui/utils/task.py
  ./backend/open_webui/env.py
  ./backend/open_webui/config.py
  ./backend/open_webui/storage/provider.py
  ./backend/open_webui/functions.py
  ./backend/open_webui/internal/wrappers.py
  ./backend/open_webui/main.py
  ./backend/open_webui/models/auths.py
  ./backend/open_webui/models/groups.py
  ./backend/open_webui/models/chats.py
  ./backend/open_webui/models/functions.py
  ./backend/open_webui/routers/tools.py
  ./backend/open_webui/routers/ollama.py
  ./backend/open_webui/routers/auths.py
  ./backend/open_webui/routers/retrieval.py
  ./backend/open_webui/routers/images.py
  ./backend/open_webui/routers/audio.py
  ./backend/open_webui/routers/chats.py
  ./backend/open_webui/routers/functions.py
  ./backend/open_webui/routers/files.py
  ./package-lock.json
  ./pyproject.toml
  ./src/routes/(app)/+page.svelte
  ./src/routes/(app)/c/[id]/+page.svelte
  ./src/routes/(app)/notes/+layout.svelte
  ./src/routes/+layout.svelte
  ./src/app.css
  ./src/lib/utils/index.ts
  ./src/lib/utils/marked/katex-extension.ts
  ./src/lib/apis/audio/index.ts
  ./src/lib/apis/ollama/index.ts
  ./src/lib/apis/chats/index.ts
  ./src/lib/apis/index.ts
  ./src/lib/apis/files/index.ts
  ./src/lib/apis/functions/index.ts
  ./src/lib/components/common/RichTextInput.svelte
  ./src/lib/components/icons/Github.svelte
  ./src/lib/components/AddServerModal.svelte
  ./src/lib/components/admin/Functions.svelte
  ./src/lib/components/admin/Users/UserList.svelte
  ./src/lib/components/admin/Users/UserList/UserChatsModal.svelte
  ./src/lib/components/admin/Functions/AddFunctionMenu.svelte
  ./src/lib/components/admin/Functions/ImportModal.svelte
  ./src/lib/components/admin/Settings/WebSearch.svelte
  ./src/lib/components/admin/Settings/Interface.svelte
  ./src/lib/components/admin/Settings/Models/ModelMenu.svelte
  ./src/lib/components/admin/Settings/Models.svelte
  ./src/lib/components/admin/Settings/General.svelte
  ./src/lib/components/admin/Settings/Documents.svelte
  ./src/lib/components/admin/Settings/Interface/Banners.svelte
  ./src/lib/components/layout/Sidebar.svelte
  ./src/lib/components/layout/Navbar.svelte
  ./src/lib/components/layout/ChatsModal.svelte
  ./src/lib/components/layout/SearchModal.svelte
  ./src/lib/components/layout/ArchivedChatsModal.svelte
  ./src/lib/components/layout/Sidebar/SearchInput.svelte
  ./src/lib/components/layout/Sidebar/UserMenu.svelte
  ./src/lib/components/workspace/Models/ModelMenu.svelte
  ./src/lib/components/workspace/Models.svelte
  ./src/lib/components/workspace/Knowledge.svelte
  ./src/lib/components/workspace/Knowledge/KnowledgeBase.svelte
  ./src/lib/components/channel/Navbar.svelte
  ./src/lib/components/channel/MessageInput.svelte
  ./src/lib/components/notes/NoteEditor.svelte
  ./src/lib/components/notes/RecordMenu.svelte
  ./src/lib/components/chat/Navbar.svelte
  ./src/lib/components/chat/Chat.svelte
  ./src/lib/components/chat/Placeholder.svelte
  ./src/lib/components/chat/Messages/Markdown/AlertRenderer.svelte
  ./src/lib/components/chat/Messages/ResponseMessage.svelte
  ./src/lib/components/chat/Messages/CitationsModal.svelte
  ./src/lib/components/chat/Suggestions.svelte
  ./src/lib/components/chat/MessageInput/VoiceRecording.svelte
  ./src/lib/components/chat/MessageInput/CallOverlay.svelte
  ./src/lib/components/chat/ContentRenderer/FloatingButtons.svelte
  ./src/lib/components/chat/MessageInput.svelte
  ./src/lib/components/chat/Settings/Personalization/EditMemoryModal.svelte
  ./src/lib/components/chat/Settings/Personalization/AddMemoryModal.svelte
  ./src/lib/components/chat/Settings/Chats.svelte
  ./src/lib/components/chat/Settings/Advanced/AdvancedParams.svelte
  ./src/lib/components/chat/Settings/Audio.svelte
  ./src/lib/components/chat/ModelSelector/Selector.svelte
  ./src/lib/i18n/locales/id-ID/translation.json
  ./src/lib/i18n/locales/nb-NO/translation.json
  ./src/lib/i18n/locales/el-GR/translation.json
  ./src/lib/i18n/locales/bo-TB/translation.json
  ./src/lib/i18n/locales/en-US/translation.json
  ./src/lib/i18n/locales/pl-PL/translation.json
  ./src/lib/i18n/locales/ceb-PH/translation.json
  ./src/lib/i18n/locales/hu-HU/translation.json
  ./src/lib/i18n/locales/da-DK/translation.json
  ./src/lib/i18n/locales/cs-CZ/translation.json
  ./src/lib/i18n/locales/ms-MY/translation.json
  ./src/lib/i18n/locales/dg-DG/translation.json
  ./src/lib/i18n/locales/pa-IN/translation.json
  ./src/lib/i18n/locales/fr-CA/translation.json
  ./src/lib/i18n/locales/sr-RS/translation.json
  ./src/lib/i18n/locales/vi-VN/translation.json
  ./src/lib/i18n/locales/ro-RO/translation.json
  ./src/lib/i18n/locales/et-EE/translation.json
  ./src/lib/i18n/locales/lt-LT/translation.json
  ./src/lib/i18n/locales/ar-BH/translation.json
  ./src/lib/i18n/locales/zh-CN/translation.json
  ./src/lib/i18n/locales/fr-FR/translation.json
  ./src/lib/i18n/locales/hi-IN/translation.json
  ./src/lib/i18n/locales/bg-BG/translation.json
  ./src/lib/i18n/locales/it-IT/translation.json
  ./src/lib/i18n/locales/tk-TW/translation.json
  ./src/lib/i18n/locales/ru-RU/translation.json
  ./src/lib/i18n/locales/he-IL/translation.json
  ./src/lib/i18n/locales/ca-ES/translation.json
  ./src/lib/i18n/locales/ka-GE/translation.json
  ./src/lib/i18n/locales/ko-KR/translation.json
  ./src/lib/i18n/locales/tr-TR/translation.json
  ./src/lib/i18n/locales/de-DE/translation.json
  ./src/lib/i18n/locales/eu-ES/translation.json
  ./src/lib/i18n/locales/hr-HR/translation.json
  ./src/lib/i18n/locales/ja-JP/translation.json
  ./src/lib/i18n/locales/sk-SK/translation.json
  ./src/lib/i18n/locales/ar/translation.json
  ./src/lib/i18n/locales/fa-IR/translation.json
  ./src/lib/i18n/locales/ur-PK/translation.json
  ./src/lib/i18n/locales/pt-PT/translation.json
  ./src/lib/i18n/locales/zh-TW/translation.json
  ./src/lib/i18n/locales/ie-GA/translation.json
  ./src/lib/i18n/locales/nl-NL/translation.json
  ./src/lib/i18n/locales/fi-FI/translation.json
  ./src/lib/i18n/locales/uk-UA/translation.json
  ./src/lib/i18n/locales/en-GB/translation.json
  ./src/lib/i18n/locales/bn-BD/translation.json
  ./src/lib/i18n/locales/th-TH/translation.json
  ./src/lib/i18n/locales/pt-BR/translation.json
  ./src/lib/i18n/locales/sv-SE/translation.json
  ./src/lib/i18n/locales/es-ES/translation.json
  ./CHANGELOG.md
  ./.github/ISSUE_TEMPLATE/bug_report.yaml
```

*Generated by script on 2025-05-27 02:03:05*

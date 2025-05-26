# Implementation Guide: Marker Api Content Extraction

**Generated on:** 2025-05-26 15:38:55  
**Repository:** `open_webui`  
**Feature Branch:** `marker-api-content-extraction` (commit: 1f5dbbb64)  
**Base Branch:** `main`

## Overview

This document contains the complete diff between the `marker-api-content-extraction` branch and the `main` branch, showing all changes made to implement the feature.

All modified and new files have been extracted from the feature branch and copied to the `modified_files/` directory, preserving the original project structure.

## Summary Statistics

 backend/open_webui/config.py                       |  49 ++++
 backend/open_webui/main.py                         |  16 ++
 .../retrieval/loaders/datalab_marker_loader.py     | 193 +++++++++++++++
 backend/open_webui/retrieval/loaders/main.py       |  25 +-
 backend/open_webui/routers/retrieval.py            |  78 ++++++-
 src/lib/components/admin/Settings/Documents.svelte | 259 +++++++++++++++++++--
 6 files changed, 595 insertions(+), 25 deletions(-)

## Files Changed

The following files were modified, added, or deleted:

- **Modified:** `backend/open_webui/config.py` → copied to `modified_files/backend/open_webui/config.py`
- **Modified:** `backend/open_webui/main.py` → copied to `modified_files/backend/open_webui/main.py`
- **Added:** `backend/open_webui/retrieval/loaders/datalab_marker_loader.py` → copied to `modified_files/backend/open_webui/retrieval/loaders/datalab_marker_loader.py`
- **Modified:** `backend/open_webui/retrieval/loaders/main.py` → copied to `modified_files/backend/open_webui/retrieval/loaders/main.py`
- **Modified:** `backend/open_webui/routers/retrieval.py` → copied to `modified_files/backend/open_webui/routers/retrieval.py`
- **Modified:** `src/lib/components/admin/Settings/Documents.svelte` → copied to `modified_files/src/lib/components/admin/Settings/Documents.svelte`

## File Manifest

See [`file_manifest.md`](./file_manifest.md) for detailed information about copied files.

---

## Detailed Changes

The following sections show the complete diff for each file:

```diff
diff --git a/backend/open_webui/config.py b/backend/open_webui/config.py
index b1955b056..2edf1bf02 100644
--- a/backend/open_webui/config.py
+++ b/backend/open_webui/config.py
@@ -1848,6 +1848,55 @@ CONTENT_EXTRACTION_ENGINE = PersistentConfig(
     os.environ.get("CONTENT_EXTRACTION_ENGINE", "").lower(),
 )
 
+DATALAB_MARKER_API_KEY = PersistentConfig(
+    "DATALAB_MARKER_API_KEY",
+    "rag.datalab_marker_api_key",
+    os.environ.get("DATALAB_MARKER_API_KEY", ""),
+)
+
+# Optional hints for language(s) and max pages
+DATALAB_MARKER_LANGS = PersistentConfig(
+    "DATALAB_MARKER_LANGS",
+    "rag.datalab_marker_langs",
+    os.environ.get("DATALAB_MARKER_LANGS", ""),  # e.g. "en,fr"
+)
+
+DATALAB_MARKER_USE_LLM = PersistentConfig(
+    "DATALAB_MARKER_USE_LLM",
+    "rag.DATALAB_MARKER_USE_LLM",
+    os.environ.get("DATALAB_MARKER_USE_LLM", "false") == "true",
+)
+
+DATALAB_MARKER_SKIP_CACHE = PersistentConfig(
+    "DATALAB_MARKER_SKIP_CACHE",
+    "rag.datalab_marker_skip_cache",
+    os.environ.get("DATALAB_MARKER_SKIP_CACHE", "false") == "true",
+)
+
+DATALAB_MARKER_FORCE_OCR = PersistentConfig(
+    "DATALAB_MARKER_FORCE_OCR",
+    "rag.datalab_marker_force_ocr",
+    os.environ.get("DATALAB_MARKER_FORCE_OCR", "false") == "true",
+)
+
+DATALAB_MARKER_PAGINATE = PersistentConfig(
+    "DATALAB_MARKER_PAGINATE",
+    "rag.datalab_marker_paginate",
+    os.environ.get("DATALAB_MARKER_PAGINATE", "false") == "true",
+)
+
+DATALAB_MARKER_STRIP_EXISTING_OCR = PersistentConfig(
+    "DATALAB_MARKER_STRIP_EXISTING_OCR",
+    "rag.datalab_marker_strip_existing_ocr",
+    os.environ.get("DATALAB_MARKER_STRIP_EXISTING_OCR", "false") == "true",
+)
+
+DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION = PersistentConfig(
+    "DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION",
+    "rag.datalab_marker_disable_image_extraction",
+    os.environ.get("DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION", "false") == "true",
+)
+
 EXTERNAL_DOCUMENT_LOADER_URL = PersistentConfig(
     "EXTERNAL_DOCUMENT_LOADER_URL",
     "rag.external_document_loader_url",
diff --git a/backend/open_webui/main.py b/backend/open_webui/main.py
index a5aee4bb8..61abf28f7 100644
--- a/backend/open_webui/main.py
+++ b/backend/open_webui/main.py
@@ -207,6 +207,14 @@ from open_webui.config import (
     CHUNK_OVERLAP,
     CHUNK_SIZE,
     CONTENT_EXTRACTION_ENGINE,
+    DATALAB_MARKER_API_KEY,
+    DATALAB_MARKER_LANGS,
+    DATALAB_MARKER_SKIP_CACHE,
+    DATALAB_MARKER_FORCE_OCR,
+    DATALAB_MARKER_PAGINATE,
+    DATALAB_MARKER_STRIP_EXISTING_OCR,
+    DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION,
+    DATALAB_MARKER_USE_LLM,
     EXTERNAL_DOCUMENT_LOADER_URL,
     EXTERNAL_DOCUMENT_LOADER_API_KEY,
     TIKA_SERVER_URL,
@@ -657,6 +665,14 @@ app.state.config.ENABLE_RAG_HYBRID_SEARCH = ENABLE_RAG_HYBRID_SEARCH
 app.state.config.ENABLE_WEB_LOADER_SSL_VERIFICATION = ENABLE_WEB_LOADER_SSL_VERIFICATION
 
 app.state.config.CONTENT_EXTRACTION_ENGINE = CONTENT_EXTRACTION_ENGINE
+app.state.config.DATALAB_MARKER_API_KEY = DATALAB_MARKER_API_KEY
+app.state.config.DATALAB_MARKER_LANGS = DATALAB_MARKER_LANGS
+app.state.config.DATALAB_MARKER_SKIP_CACHE = DATALAB_MARKER_SKIP_CACHE
+app.state.config.DATALAB_MARKER_FORCE_OCR = DATALAB_MARKER_FORCE_OCR
+app.state.config.DATALAB_MARKER_PAGINATE = DATALAB_MARKER_PAGINATE
+app.state.config.DATALAB_MARKER_STRIP_EXISTING_OCR = DATALAB_MARKER_STRIP_EXISTING_OCR
+app.state.config.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION = DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION
+app.state.config.DATALAB_MARKER_USE_LLM = DATALAB_MARKER_USE_LLM
 app.state.config.EXTERNAL_DOCUMENT_LOADER_URL = EXTERNAL_DOCUMENT_LOADER_URL
 app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY = EXTERNAL_DOCUMENT_LOADER_API_KEY
 app.state.config.TIKA_SERVER_URL = TIKA_SERVER_URL
diff --git a/backend/open_webui/retrieval/loaders/datalab_marker_loader.py b/backend/open_webui/retrieval/loaders/datalab_marker_loader.py
new file mode 100644
index 000000000..45a397c96
--- /dev/null
+++ b/backend/open_webui/retrieval/loaders/datalab_marker_loader.py
@@ -0,0 +1,193 @@
+import os
+import time
+import requests
+import logging
+import json
+from typing import List, Optional
+from langchain_core.documents import Document
+from fastapi import HTTPException, status
+
+log = logging.getLogger(__name__)
+
+
+class DatalabMarkerLoader:
+    def __init__(
+        self,
+        file_path: str,
+        api_key: str,
+        langs: Optional[str] = None,
+        use_llm: bool = False,
+        skip_cache: bool = False,
+        force_ocr: bool = False,
+        paginate: bool = False,
+        strip_existing_ocr: bool = False,
+        disable_image_extraction: bool = False,
+        output_format: str = "markdown"
+    ):
+        self.file_path = file_path
+        self.api_key = api_key
+        self.langs = langs or "English"
+        self.use_llm = use_llm
+        self.skip_cache = skip_cache
+        self.force_ocr = force_ocr
+        self.paginate = paginate
+        self.strip_existing_ocr = strip_existing_ocr
+        self.disable_image_extraction = disable_image_extraction
+        self.output_format = output_format
+
+    def _get_mime_type(self, filename: str) -> str:
+        ext = filename.rsplit(".", 1)[-1].lower()
+        mime_map = {
+            'pdf': 'application/pdf',
+            'xls': 'application/vnd.ms-excel',
+            'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
+            'ods': 'application/vnd.oasis.opendocument.spreadsheet',
+            'doc': 'application/msword',
+            'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
+            'odt': 'application/vnd.oasis.opendocument.text',
+            'ppt': 'application/vnd.ms-powerpoint',
+            'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
+            'odp': 'application/vnd.oasis.opendocument.presentation',
+            'html': 'text/html',
+            'epub': 'application/epub+zip',
+            'png': 'image/png',
+            'jpeg': 'image/jpeg',
+            'jpg': 'image/jpeg',
+            'webp': 'image/webp',
+            'gif': 'image/gif',
+            'tiff': 'image/tiff'
+        }
+        return mime_map.get(ext, 'application/octet-stream')
+
+    def check_marker_request_status(self, request_id: str) -> dict:
+        url = f"https://www.datalab.to/api/v1/marker/{request_id}"
+        headers = {"X-Api-Key": self.api_key}
+        try:
+            response = requests.get(url, headers=headers)
+            response.raise_for_status()
+            result = response.json()
+            log.info(f"Marker API status check for request {request_id}: {result}")
+            return result
+        except requests.HTTPError as e:
+            log.error(f"Error checking Marker request status: {e}")
+            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Failed to check Marker request: {e}")
+        except ValueError as e:
+            log.error(f"Invalid JSON checking Marker request: {e}")
+            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Invalid JSON: {e}")
+
+    def load(self) -> List[Document]:
+        url = "https://www.datalab.to/api/v1/marker"
+        filename = os.path.basename(self.file_path)
+        mime_type = self._get_mime_type(filename)
+        headers = {"X-Api-Key": self.api_key}
+
+        form_data = {}
+
+        if self.langs:
+            form_data['langs'] = (None, self.langs)
+        form_data['use_llm'] = (None, str(self.use_llm).lower())
+        form_data['skip_cache'] = (None, str(self.skip_cache).lower())
+        form_data['force_ocr'] = (None, str(self.force_ocr).lower())
+        form_data['paginate'] = (None, str(self.paginate).lower())
+        form_data['strip_existing_ocr'] = (None, str(self.strip_existing_ocr).lower())
+        form_data['disable_image_extraction'] = (None, str(self.disable_image_extraction).lower())
+        form_data['output_format'] = (None, self.output_format)
+
+        request_params = {
+            'url': url,
+            'filename': filename,
+            'mime_type': mime_type,
+            'langs': self.langs,
+            'use_llm': self.use_llm,
+            'skip_cache': self.skip_cache,
+            'force_ocr': self.force_ocr,
+            'paginate': self.paginate,
+            'strip_existing_ocr': self.strip_existing_ocr,
+            'disable_image_extraction': self.disable_image_extraction,
+            'output_format': self.output_format,
+        }
+        log.info(f"Datalab Marker POST request parameters: {request_params}")
+
+        try:
+            with open(self.file_path, "rb") as f:
+                form_data['file'] = (filename, f, mime_type)
+                response = requests.post(url, files=form_data, headers=headers)
+        except FileNotFoundError:
+            log.error(f"File not found: {self.file_path}")
+            raise HTTPException(status.HTTP_404_NOT_FOUND, detail=f"File not found: {self.file_path}")
+        except Exception as e:
+            log.error(f"Error reading file: {e}")
+            raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error reading file: {e}")
+
+        try:
+            response.raise_for_status()
+            result = response.json()
+        except requests.HTTPError as e:
+            log.error(f"Datalab Marker request failed: {e}")
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Datalab Marker request failed: {e}")
+        except ValueError as e:
+            log.error(f"Invalid JSON response: {e}")
+            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Invalid JSON response: {e}")
+
+        if not result.get("success", False):
+            error_msg = result.get("error") or "Unknown error"
+            log.error(f"Datalab Marker request failed: {error_msg}")
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Datalab Marker request failed: {error_msg}")
+
+        check_url = result.get("request_check_url")
+        request_id = result.get("request_id")
+        if not check_url:
+            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail="No request_check_url returned.")
+
+        # Polling loop
+        for _ in range(300):  # Up to 10 minutes
+            time.sleep(2)
+            try:
+                poll_response = requests.get(check_url, headers=headers)
+                poll_response.raise_for_status()
+                poll_result = poll_response.json()
+            except (requests.HTTPError, ValueError) as e:
+                log.error(f"Polling error: {e}")
+                raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Polling failed: {e}")
+
+            if poll_result.get("status") == "complete":
+                break
+            if not poll_result.get("success", True):
+                error_msg = poll_result.get("error") or "Unknown processing error"
+                raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Marker processing failed: {error_msg}")
+        else:
+            raise HTTPException(status.HTTP_504_GATEWAY_TIMEOUT, detail="Marker processing timed out")
+
+        if not poll_result.get("success", False):
+            error_msg = poll_result.get("error") or "Unknown processing error"
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Final processing failed: {error_msg}")
+
+        content_key = self.output_format.lower()
+        if content_key not in poll_result:
+            content_key = "markdown"
+        full_text = poll_result.get(content_key, "")
+
+        if not full_text.strip():
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail="Datalab Marker returned empty content")
+
+        metadata = {
+            "source": filename,
+            "output_format": poll_result.get("output_format", self.output_format),
+            "page_count": poll_result.get("page_count", 0),
+            "processed_with_llm": self.use_llm,
+            "request_id": request_id or "",
+        }
+
+        images = poll_result.get("images", {})
+        if images:
+            metadata["image_count"] = len(images)
+            metadata["images"] = json.dumps(list(images.keys()))
+
+        for key, value in metadata.items():
+            if value is None:
+                metadata[key] = ""
+            elif isinstance(value, (list, dict)):
+                metadata[key] = json.dumps(value)
+
+        #log.info(f"Processed {filename}: {metadata['page_count']} pages, {len(full_text)} characters.")
+        return [Document(page_content=full_text, metadata=metadata)]
diff --git a/backend/open_webui/retrieval/loaders/main.py b/backend/open_webui/retrieval/loaders/main.py
index c5f0b4e5e..043bd5159 100644
--- a/backend/open_webui/retrieval/loaders/main.py
+++ b/backend/open_webui/retrieval/loaders/main.py
@@ -21,7 +21,7 @@ from langchain_community.document_loaders import (
 )
 from langchain_core.documents import Document
 
-
+from open_webui.retrieval.loaders.datalab_marker_loader import DatalabMarkerLoader
 from open_webui.retrieval.loaders.external_document import ExternalDocumentLoader
 from open_webui.retrieval.loaders.mistral import MistralLoader
 
@@ -215,6 +215,27 @@ class Loader:
     def _get_loader(self, filename: str, file_content_type: str, file_path: str):
         file_ext = filename.split(".")[-1].lower()
 
+        if (
+            self.engine == "datalab_marker"
+            and self.kwargs.get("DATALAB_MARKER_API_KEY")
+            and file_ext in [
+                "pdf", "xls", "xlsx", "ods", "doc", "docx", "odt", "ppt",
+                "pptx", "odp", "html", "epub", "png", "jpeg", "jpg", "webp",
+                "gif", "tiff"
+            ]
+        ):
+            return DatalabMarkerLoader(
+                file_path=file_path,
+                api_key=self.kwargs["DATALAB_MARKER_API_KEY"],
+                langs=self.kwargs.get("DATALAB_MARKER_LANGS"),
+                use_llm=self.kwargs.get("DATALAB_MARKER_USE_LLM", False),
+                skip_cache=self.kwargs.get("DATALAB_MARKER_SKIP_CACHE", False),
+                force_ocr=self.kwargs.get("DATALAB_MARKER_FORCE_OCR", False),
+                paginate=self.kwargs.get("DATALAB_MARKER_PAGINATE", False),
+                strip_existing_ocr=self.kwargs.get("DATALAB_MARKER_STRIP_EXISTING_OCR", False),
+                disable_image_extraction=self.kwargs.get("DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION", False),
+                output_format=self.kwargs.get("DATALAB_MARKER_OUTPUT_FORMAT", "markdown")
+            )
         if (
             self.engine == "external"
             and self.kwargs.get("EXTERNAL_DOCUMENT_LOADER_URL")
@@ -331,4 +352,4 @@ class Loader:
             else:
                 loader = TextLoader(file_path, autodetect_encoding=True)
 
-        return loader
+        return loader
\ No newline at end of file
diff --git a/backend/open_webui/routers/retrieval.py b/backend/open_webui/routers/retrieval.py
index 5cb47373f..1fa7ed499 100644
--- a/backend/open_webui/routers/retrieval.py
+++ b/backend/open_webui/routers/retrieval.py
@@ -352,6 +352,14 @@ async def get_rag_config(request: Request, user=Depends(get_admin_user)):
         # Content extraction settings
         "CONTENT_EXTRACTION_ENGINE": request.app.state.config.CONTENT_EXTRACTION_ENGINE,
         "PDF_EXTRACT_IMAGES": request.app.state.config.PDF_EXTRACT_IMAGES,
+        "DATALAB_MARKER_API_KEY": request.app.state.config.DATALAB_MARKER_API_KEY,
+        "DATALAB_MARKER_LANGS": request.app.state.config.DATALAB_MARKER_LANGS,
+        "DATALAB_MARKER_SKIP_CACHE": request.app.state.config.DATALAB_MARKER_SKIP_CACHE,
+        "DATALAB_MARKER_FORCE_OCR": request.app.state.config.DATALAB_MARKER_FORCE_OCR,
+        "DATALAB_MARKER_PAGINATE": request.app.state.config.DATALAB_MARKER_PAGINATE,
+        "DATALAB_MARKER_STRIP_EXISTING_OCR": request.app.state.config.DATALAB_MARKER_STRIP_EXISTING_OCR,
+        "DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION": request.app.state.config.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION,
+        "DATALAB_MARKER_USE_LLM": request.app.state.config.DATALAB_MARKER_USE_LLM,
         "EXTERNAL_DOCUMENT_LOADER_URL": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL,
         "EXTERNAL_DOCUMENT_LOADER_API_KEY": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY,
         "TIKA_SERVER_URL": request.app.state.config.TIKA_SERVER_URL,
@@ -496,6 +504,14 @@ class ConfigForm(BaseModel):
     # Content extraction settings
     CONTENT_EXTRACTION_ENGINE: Optional[str] = None
     PDF_EXTRACT_IMAGES: Optional[bool] = None
+    DATALAB_MARKER_API_KEY: Optional[str] = None
+    DATALAB_MARKER_LANGS: Optional[str] = None
+    DATALAB_MARKER_SKIP_CACHE: Optional[bool] = None
+    DATALAB_MARKER_FORCE_OCR: Optional[bool] = None
+    DATALAB_MARKER_PAGINATE: Optional[bool] = None
+    DATALAB_MARKER_STRIP_EXISTING_OCR: Optional[bool] = None
+    DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION: Optional[bool] = None
+    DATALAB_MARKER_USE_LLM: Optional[bool] = None
     EXTERNAL_DOCUMENT_LOADER_URL: Optional[str] = None
     EXTERNAL_DOCUMENT_LOADER_API_KEY: Optional[str] = None
 
@@ -590,6 +606,46 @@ async def update_rag_config(
         if form_data.PDF_EXTRACT_IMAGES is not None
         else request.app.state.config.PDF_EXTRACT_IMAGES
     )
+    request.app.state.config.DATALAB_MARKER_API_KEY = (
+        form_data.DATALAB_MARKER_API_KEY
+        if form_data.DATALAB_MARKER_API_KEY is not None
+        else request.app.state.config.DATALAB_MARKER_API_KEY
+    )
+    request.app.state.config.DATALAB_MARKER_LANGS = (
+        form_data.DATALAB_MARKER_LANGS
+        if form_data.DATALAB_MARKER_LANGS is not None
+        else request.app.state.config.DATALAB_MARKER_LANGS
+    )
+    request.app.state.config.DATALAB_MARKER_SKIP_CACHE = (
+        form_data.DATALAB_MARKER_SKIP_CACHE
+        if form_data.DATALAB_MARKER_SKIP_CACHE is not None
+        else request.app.state.config.DATALAB_MARKER_SKIP_CACHE
+    )
+    request.app.state.config.DATALAB_MARKER_FORCE_OCR = (
+        form_data.DATALAB_MARKER_FORCE_OCR
+        if form_data.DATALAB_MARKER_FORCE_OCR is not None
+        else request.app.state.config.DATALAB_MARKER_FORCE_OCR
+    )
+    request.app.state.config.DATALAB_MARKER_PAGINATE = (
+        form_data.DATALAB_MARKER_PAGINATE
+        if form_data.DATALAB_MARKER_PAGINATE is not None
+        else request.app.state.config.DATALAB_MARKER_PAGINATE
+    )
+    request.app.state.config.DATALAB_MARKER_STRIP_EXISTING_OCR = (
+        form_data.DATALAB_MARKER_STRIP_EXISTING_OCR
+        if form_data.DATALAB_MARKER_STRIP_EXISTING_OCR is not None
+        else request.app.state.config.DATALAB_MARKER_STRIP_EXISTING_OCR
+    )
+    request.app.state.config.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION = (
+        form_data.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION
+        if form_data.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION is not None
+        else request.app.state.config.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION
+    )
+    request.app.state.config.DATALAB_MARKER_USE_LLM = (
+        form_data.DATALAB_MARKER_USE_LLM
+        if form_data.DATALAB_MARKER_USE_LLM is not None
+        else request.app.state.config.DATALAB_MARKER_USE_LLM
+    )
     request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL = (
         form_data.EXTERNAL_DOCUMENT_LOADER_URL
         if form_data.EXTERNAL_DOCUMENT_LOADER_URL is not None
@@ -840,6 +896,14 @@ async def update_rag_config(
         # Content extraction settings
         "CONTENT_EXTRACTION_ENGINE": request.app.state.config.CONTENT_EXTRACTION_ENGINE,
         "PDF_EXTRACT_IMAGES": request.app.state.config.PDF_EXTRACT_IMAGES,
+        "DATALAB_MARKER_API_KEY": request.app.state.config.DATALAB_MARKER_API_KEY,
+        "DATALAB_MARKER_LANGS": request.app.state.config.DATALAB_MARKER_LANGS,
+        "DATALAB_MARKER_SKIP_CACHE": request.app.state.config.DATALAB_MARKER_SKIP_CACHE,
+        "DATALAB_MARKER_FORCE_OCR": request.app.state.config.DATALAB_MARKER_FORCE_OCR,
+        "DATALAB_MARKER_PAGINATE": request.app.state.config.DATALAB_MARKER_PAGINATE,
+        "DATALAB_MARKER_STRIP_EXISTING_OCR": request.app.state.config.DATALAB_MARKER_STRIP_EXISTING_OCR,
+        "DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION": request.app.state.config.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION,
+        "DATALAB_MARKER_USE_LLM": request.app.state.config.DATALAB_MARKER_USE_LLM,
         "EXTERNAL_DOCUMENT_LOADER_URL": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL,
         "EXTERNAL_DOCUMENT_LOADER_API_KEY": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY,
         "TIKA_SERVER_URL": request.app.state.config.TIKA_SERVER_URL,
@@ -1011,11 +1075,13 @@ def save_docs_to_vector_db(
         for doc in docs
     ]
 
-    # ChromaDB does not like datetime formats
+    # ChromaDB does not like datetime formats or None values
     # for meta-data so convert them to string.
     for metadata in metadatas:
         for key, value in metadata.items():
-            if (
+            if value is None:
+                metadata[key] = ""  # Convert None to empty string
+            elif (
                 isinstance(value, datetime)
                 or isinstance(value, list)
                 or isinstance(value, dict)
@@ -1164,6 +1230,14 @@ def process_file(
                 file_path = Storage.get_file(file_path)
                 loader = Loader(
                     engine=request.app.state.config.CONTENT_EXTRACTION_ENGINE,
+                    DATALAB_MARKER_API_KEY=request.app.state.config.DATALAB_MARKER_API_KEY,
+                    DATALAB_MARKER_LANGS=request.app.state.config.DATALAB_MARKER_LANGS,
+                    DATALAB_MARKER_SKIP_CACHE=request.app.state.config.DATALAB_MARKER_SKIP_CACHE,
+                    DATALAB_MARKER_FORCE_OCR=request.app.state.config.DATALAB_MARKER_FORCE_OCR,
+                    DATALAB_MARKER_PAGINATE=request.app.state.config.DATALAB_MARKER_PAGINATE,
+                    DATALAB_MARKER_STRIP_EXISTING_OCR=request.app.state.config.DATALAB_MARKER_STRIP_EXISTING_OCR,
+                    DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION=request.app.state.config.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION,
+                    DATALAB_MARKER_USE_LLM=request.app.state.config.DATALAB_MARKER_USE_LLM,
                     EXTERNAL_DOCUMENT_LOADER_URL=request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL,
                     EXTERNAL_DOCUMENT_LOADER_API_KEY=request.app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY,
                     TIKA_SERVER_URL=request.app.state.config.TIKA_SERVER_URL,
diff --git a/src/lib/components/admin/Settings/Documents.svelte b/src/lib/components/admin/Settings/Documents.svelte
index 0660dc7ae..c7e1bd15f 100644
--- a/src/lib/components/admin/Settings/Documents.svelte
+++ b/src/lib/components/admin/Settings/Documents.svelte
@@ -125,42 +125,48 @@
 
 	const submitHandler = async () => {
 		if (
-			RAGConfig.CONTENT_EXTRACTION_ENGINE === 'external' &&
-			RAGConfig.EXTERNAL_DOCUMENT_LOADER_URL === ''
+		  RAGConfig.CONTENT_EXTRACTION_ENGINE === 'datalab_marker' &&
+		  !RAGConfig.DATALAB_MARKER_API_KEY
 		) {
+		  toast.error($i18n.t('Datalab Marker API Key required.'));
+		  return;
+		}
+		if (RAGConfig.CONTENT_EXTRACTION_ENGINE === 'external' && !RAGConfig.EXTERNAL_DOCUMENT_LOADER_URL) {
 			toast.error($i18n.t('External Document Loader URL required.'));
 			return;
 		}
-		if (RAGConfig.CONTENT_EXTRACTION_ENGINE === 'tika' && RAGConfig.TIKA_SERVER_URL === '') {
+		if (RAGConfig.CONTENT_EXTRACTION_ENGINE === 'external' && !RAGConfig.EXTERNAL_DOCUMENT_LOADER_API_KEY) {
+			toast.error($i18n.t('External Document Loader API Key required.'));
+			return;
+		}
+		if (RAGConfig.CONTENT_EXTRACTION_ENGINE === 'tika' && !RAGConfig.TIKA_SERVER_URL) {
 			toast.error($i18n.t('Tika Server URL required.'));
 			return;
 		}
-		if (RAGConfig.CONTENT_EXTRACTION_ENGINE === 'docling' && RAGConfig.DOCLING_SERVER_URL === '') {
+		if (RAGConfig.CONTENT_EXTRACTION_ENGINE === 'docling' && !RAGConfig.DOCLING_SERVER_URL) {
 			toast.error($i18n.t('Docling Server URL required.'));
 			return;
 		}
 		if (
 			RAGConfig.CONTENT_EXTRACTION_ENGINE === 'docling' &&
 			((RAGConfig.DOCLING_OCR_ENGINE === '' && RAGConfig.DOCLING_OCR_LANG !== '') ||
-				(RAGConfig.DOCLING_OCR_ENGINE !== '' && RAGConfig.DOCLING_OCR_LANG === ''))
+			(RAGConfig.DOCLING_OCR_ENGINE !== '' && RAGConfig.DOCLING_OCR_LANG === ''))
 		) {
 			toast.error(
-				$i18n.t('Both Docling OCR Engine and Language(s) must be provided or both left empty.')
+			$i18n.t('Both Docling OCR Engine and Language(s) must be provided or both left empty.')
 			);
 			return;
 		}
-
 		if (
 			RAGConfig.CONTENT_EXTRACTION_ENGINE === 'document_intelligence' &&
-			(RAGConfig.DOCUMENT_INTELLIGENCE_ENDPOINT === '' ||
-				RAGConfig.DOCUMENT_INTELLIGENCE_KEY === '')
+			(!RAGConfig.DOCUMENT_INTELLIGENCE_ENDPOINT || !RAGConfig.DOCUMENT_INTELLIGENCE_KEY)
 		) {
 			toast.error($i18n.t('Document Intelligence endpoint and key required.'));
 			return;
 		}
 		if (
 			RAGConfig.CONTENT_EXTRACTION_ENGINE === 'mistral_ocr' &&
-			RAGConfig.MISTRAL_OCR_API_KEY === ''
+			!RAGConfig.MISTRAL_OCR_API_KEY
 		) {
 			toast.error($i18n.t('Mistral OCR API Key required.'));
 			return;
@@ -170,7 +176,7 @@
 			await embeddingModelUpdateHandler();
 		}
 
-		RAGConfig.ALLOWED_FILE_EXTENSIONS = (RAGConfig?.ALLOWED_FILE_EXTENSIONS ?? '')
+		RAGConfig.ALLOWED_FILE_EXTENSIONS = (RAGConfig.ALLOWED_FILE_EXTENSIONS ?? '')
 			.split(',')
 			.map((ext) => ext.trim())
 			.filter((ext) => ext !== '');
@@ -202,6 +208,111 @@
 
 		RAGConfig = config;
 	});
+
+	const SUPPORTED_LANGUAGES = {
+		"_math": "Math",
+		"af": "Afrikaans",
+		"am": "Amharic",
+		"ar": "Arabic",
+		"as": "Assamese",
+		"az": "Azerbaijani",
+		"be": "Belarusian",
+		"bg": "Bulgarian",
+		"bn": "Bengali",
+		"br": "Breton",
+		"bs": "Bosnian",
+		"ca": "Catalan",
+		"cs": "Czech",
+		"cy": "Welsh",
+		"da": "Danish",
+		"de": "German",
+		"el": "Greek",
+		"en": "English",
+		"eo": "Esperanto",
+		"es": "Spanish",
+		"et": "Estonian",
+		"eu": "Basque",
+		"fa": "Persian",
+		"fi": "Finnish",
+		"fr": "French",
+		"fy": "Western Frisian",
+		"ga": "Irish",
+		"gd": "Scottish Gaelic",
+		"gl": "Galician",
+		"gu": "Gujarati",
+		"ha": "Hausa",
+		"he": "Hebrew",
+		"hi": "Hindi",
+		"hr": "Croatian",
+		"hu": "Hungarian",
+		"hy": "Armenian",
+		"id": "Indonesian",
+		"is": "Icelandic",
+		"it": "Italian",
+		"ja": "Japanese",
+		"jv": "Javanese",
+		"ka": "Georgian",
+		"kk": "Kazakh",
+		"km": "Khmer",
+		"kn": "Kannada",
+		"ko": "Korean",
+		"ku": "Kurdish",
+		"ky": "Kyrgyz",
+		"la": "Latin",
+		"lo": "Lao",
+		"lt": "Lithuanian",
+		"lv": "Latvian",
+		"mg": "Malagasy",
+		"mk": "Macedonian",
+		"ml": "Malayalam",
+		"mn": "Mongolian",
+		"mr": "Marathi",
+		"ms": "Malay",
+		"my": "Burmese",
+		"ne": "Nepali",
+		"nl": "Dutch",
+		"no": "Norwegian",
+		"om": "Oromo",
+		"or": "Oriya",
+		"pa": "Punjabi",
+		"pl": "Polish",
+		"ps": "Pashto",
+		"pt": "Portuguese",
+		"ro": "Romanian",
+		"ru": "Russian",
+		"sa": "Sanskrit",
+		"sd": "Sindhi",
+		"si": "Sinhala",
+		"sk": "Slovak",
+		"sl": "Slovenian",
+		"so": "Somali",
+		"sq": "Albanian",
+		"sr": "Serbian",
+		"su": "Sundanese",
+		"sv": "Swedish",
+		"sw": "Swahili",
+		"ta": "Tamil",
+		"te": "Telugu",
+		"th": "Thai",
+		"tl": "Tagalog",
+		"tr": "Turkish",
+		"ug": "Uyghur",
+		"uk": "Ukrainian",
+		"ur": "Urdu",
+		"uz": "Uzbek",
+		"vi": "Vietnamese",
+		"xh": "Xhosa",
+		"yi": "Yiddish",
+		"zh": "Chinese",
+	}
+
+	let selectedLanguages: string[] = ['en'];
+
+	$: if (RAGConfig) {
+		RAGConfig.DATALAB_MARKER_LANGS = selectedLanguages.length
+		? selectedLanguages.join(',')
+		: null;
+	}
 </script>
 
 <ResetUploadDirConfirmDialog
@@ -271,6 +382,7 @@
 									bind:value={RAGConfig.CONTENT_EXTRACTION_ENGINE}
 								>
 									<option value="">{$i18n.t('Default')}</option>
+									<option value="datalab_marker">{ $i18n.t('Datalab Marker API') }</option>
 									<option value="external">{$i18n.t('External')}</option>
 									<option value="tika">{$i18n.t('Tika')}</option>
 									<option value="docling">{$i18n.t('Docling')}</option>
@@ -281,16 +393,121 @@
 						</div>
 
 						{#if RAGConfig.CONTENT_EXTRACTION_ENGINE === ''}
-							<div class="flex w-full mt-1">
-								<div class="flex-1 flex justify-between">
-									<div class=" self-center text-xs font-medium">
-										{$i18n.t('PDF Extract Images (OCR)')}
-									</div>
-									<div class="flex items-center relative">
-										<Switch bind:state={RAGConfig.PDF_EXTRACT_IMAGES} />
-									</div>
-								</div>
+						  <!-- default PDF Extract Images switch -->
+						  <div class="flex w-full mt-1">
+							<div class="flex-1 flex justify-between">
+							  <div class="self-center text-xs font-medium">
+								{$i18n.t('PDF Extract Images (OCR)')}
+							  </div>
+							  <div class="flex items-center relative">
+								<Switch bind:state={RAGConfig.PDF_EXTRACT_IMAGES} />
+							  </div>
+							</div>
+						  </div>
+
+						{:else if RAGConfig.CONTENT_EXTRACTION_ENGINE === 'datalab_marker'}
+						  <div class="my-0.5 flex gap-2 pr-2">
+							<SensitiveInput
+							  placeholder={$i18n.t('Enter Datalab Marker API Key')}
+							  required={false}
+							  bind:value={RAGConfig.DATALAB_MARKER_API_KEY}
+							/>
+						  </div>
+						  <div class="my-0.5 flex gap-2 pr-2 w-full">
+							<div class="flex flex-col w-full">
+								<label class="text-xs font-medium mb-1">
+								{$i18n.t("OCR language(s). Hold Ctrl (Windows) or Cmd (Mac) to select multiple.")}
+								</label>
+								<select
+								class="w-full text-sm bg-transparent border border-gray-300 dark:border-gray-700 rounded-sm p-1 outline-hidden"
+								multiple
+								size="6"
+								bind:value={selectedLanguages}
+								>
+								{#each Object.entries(SUPPORTED_LANGUAGES) as [code, label]}
+									<option value={code}>{label}</option>
+								{/each}
+								</select>
+							</div>
+					      </div>
+							<div class="mb-1 flex w-full justify-between">
+							<div class="self-center text-xs font-medium">
+								<Tooltip content={$i18n.t('Significantly improves accuracy by using an LLM to enhance tables, forms, inline math, and layout detection. Will increase latency. Defaults to False.')} placement="top-start">
+								{$i18n.t('Use LLM')}
+								</Tooltip>
+							</div>
+							<div class="flex items-center">
+								<Switch bind:state={RAGConfig.DATALAB_MARKER_USE_LLM} />
+							</div>
+							</div>
+							<div class="mb-1 flex w-full justify-between">
+							<div class="self-center text-xs font-medium">
+								<Tooltip content={$i18n.t('Skip the cache and re-run the inference. Defaults to False.')} placement="top-start">
+								{$i18n.t('Skip Cache')}
+								</Tooltip>
+							</div>
+							<div class="flex items-center">
+								<Switch bind:state={RAGConfig.DATALAB_MARKER_SKIP_CACHE} />
+							</div>
+							</div>
+							<div class="mb-1 flex w-full justify-between">
+							<div class="self-center text-xs font-medium">
+								<Tooltip content={$i18n.t('Force OCR on all pages of the PDF. This can lead to worse results if you have good text in your PDFs. Defaults to False.')} placement="top-start">
+								{$i18n.t('Force OCR')}
+								</Tooltip>
+							</div>
+							<div class="flex items-center">
+								<Switch bind:state={RAGConfig.DATALAB_MARKER_FORCE_OCR} />
+							</div>
+							</div>
+							<div class="mb-1 flex w-full justify-between">
+							<div class="self-center text-xs font-medium">
+								<Tooltip content={$i18n.t('Whether to paginate the output. Each page will be separated by a horizontal rule and page number. Defaults to False.')} placement="top-start">
+								{$i18n.t('Paginate')}
+								</Tooltip>
+							</div>
+							<div class="flex items-center">
+								<Switch bind:state={RAGConfig.DATALAB_MARKER_PAGINATE} />
+							</div>
+							</div>
+							<div class="mb-1 flex w-full justify-between">
+							<div class="self-center text-xs font-medium">
+								<Tooltip content={$i18n.t('Strip existing OCR text from the PDF and re-run OCR. Ignored if Force OCR is enabled. Defaults to False.')} placement="top-start">
+								{$i18n.t('Strip Existing OCR')}
+								</Tooltip>
+							</div>
+							<div class="flex items-center">
+								<Switch bind:state={RAGConfig.DATALAB_MARKER_STRIP_EXISTING_OCR} />
+							</div>
+							</div>
+							<div class="mb-1 flex w-full justify-between">
+							<div class="self-center text-xs font-medium">
+								<Tooltip content={$i18n.t('Disable image extraction from the PDF. If Use LLM is enabled, images will be automatically captioned. Defaults to False.')} placement="top-start">
+								{$i18n.t('Disable Image Extraction')}
+								</Tooltip>
+							</div>
+							<div class="flex items-center">
+								<Switch bind:state={RAGConfig.DATALAB_MARKER_DISABLE_IMAGE_EXTRACTION} />
+							</div>
+							</div>
+							<div class="mb-1 flex w-full justify-between">
+							<div class="self-center text-xs font-medium">
+								<Tooltip content={$i18n.t("The output format for the text. Can be 'json', 'markdown', or 'html'. Defaults to 'markdown'.")} placement="top-start">
+								{$i18n.t('Output Format')}
+								</Tooltip>
 							</div>
+							<div class="">
+								<select
+								class="dark:bg-gray-900 w-fit pr-8 rounded-sm px-2 text-xs bg-transparent outline-hidden text-right"
+								bind:value={RAGConfig.DATALAB_MARKER_OUTPUT_FORMAT}
+								>
+								<option value="markdown">{$i18n.t('Markdown')}</option>
+								<option value="json">{$i18n.t('JSON')}</option>
+								<option value="html">{$i18n.t('HTML')}</option>
+								</select>
+							</div>
+							</div>
+
 						{:else if RAGConfig.CONTENT_EXTRACTION_ENGINE === 'external'}
 							<div class="my-0.5 flex gap-2 pr-2">
 								<input
@@ -948,4 +1165,4 @@
 			<Spinner />
 		</div>
 	{/if}
-</form>
+</form>
\ No newline at end of file
```

---

## Implementation Notes

### How to Use This Guide

1. **Review the Summary Statistics** to understand the scope of changes
2. **Check the Files Changed** section to see which files were affected
3. **Examine copied files** in the `modified_files/` directory
4. **Use the Detailed Changes** section to see exactly what was modified
5. **Check the File Manifest** for detailed information about copied files

### Git Commands Used

- **Generate this diff:** `git diff main marker-api-content-extraction`
- **View file list:** `git diff --name-status main marker-api-content-extraction`
- **View statistics:** `git diff --stat main marker-api-content-extraction`
- **Extract files:** `git show marker-api-content-extraction:path/to/file`

### Regenerating This Guide

To regenerate this guide with updated changes, run:
```bash
# From the script directory
./generate_implementation_guide.sh /path/to/repository

# With custom branches
./generate_implementation_guide.sh /path/to/repository feature-branch base-branch
```

### Usage Examples

```bash
# Generate guide for repository in current directory
./generate_implementation_guide.sh .

# Generate guide for specific repository
./generate_implementation_guide.sh /path/to/my-project

# Generate guide with custom branches
./generate_implementation_guide.sh /path/to/my-project my-feature main

# Generate guide for relative path
./generate_implementation_guide.sh ../my-project
```

---

*Generated by enhanced implementation guide script on 2025-05-26 15:38:55*

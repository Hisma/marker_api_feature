# Implementation Guide: Marker Api Content Extraction

**Generated:** 2025-05-27 02:28:44  
**Repo:**      `open-webui`  
**Feature:**   `marker-api-content-extraction`  
**Base:**      `main`  
**Merge-base:** `b8e16211b9d207e91b7da0a2055a7a679c05b6ce`

## Summary stats
 backend/open_webui/config.py                       |  54 ++++++
 backend/open_webui/main.py                         |  18 ++
 .../retrieval/loaders/datalab_marker_loader.py     | 200 +++++++++++++++++++++
 backend/open_webui/retrieval/loaders/main.py       |  19 +-
 backend/open_webui/routers/retrieval.py            |  81 +++++++++
 src/lib/components/admin/Settings/Documents.svelte | 146 +++++++++++++++
 6 files changed, 517 insertions(+), 1 deletion(-)

## Files changed
- **Modified:** `backend/open_webui/config.py` → `modified_files/backend/open_webui/config.py`
- **Modified:** `backend/open_webui/main.py` → `modified_files/backend/open_webui/main.py`
- **Added:**    `backend/open_webui/retrieval/loaders/datalab_marker_loader.py` → `modified_files/backend/open_webui/retrieval/loaders/datalab_marker_loader.py`
- **Modified:** `backend/open_webui/retrieval/loaders/main.py` → `modified_files/backend/open_webui/retrieval/loaders/main.py`
- **Modified:** `backend/open_webui/routers/retrieval.py` → `modified_files/backend/open_webui/routers/retrieval.py`
- **Modified:** `src/lib/components/admin/Settings/Documents.svelte` → `modified_files/src/lib/components/admin/Settings/Documents.svelte`

## Detailed diff

```diff
diff --git a/backend/open_webui/config.py b/backend/open_webui/config.py
index 441c99efb..e0bed082b 100644
--- a/backend/open_webui/config.py
+++ b/backend/open_webui/config.py
@@ -1848,6 +1848,60 @@ CONTENT_EXTRACTION_ENGINE = PersistentConfig(
     os.environ.get("CONTENT_EXTRACTION_ENGINE", "").lower(),
 )
 
+DATALAB_MARKER_API_KEY = PersistentConfig(
+    "DATALAB_MARKER_API_KEY",
+    "rag.datalab_marker_api_key",
+    os.environ.get("DATALAB_MARKER_API_KEY", ""),
+)
+
+DATALAB_MARKER_LANGS = PersistentConfig(
+    "DATALAB_MARKER_LANGS",
+    "rag.datalab_marker_langs",
+    os.environ.get("DATALAB_MARKER_LANGS", ""),
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
+DATALAB_MARKER_OUTPUT_FORMAT = PersistentConfig(
+    "DATALAB_MARKER_OUTPUT_FORMAT",
+    "rag.datalab_marker_output_format",
+    os.environ.get("DATALAB_MARKER_OUTPUT_FORMAT", ""),
+)
+
 EXTERNAL_DOCUMENT_LOADER_URL = PersistentConfig(
     "EXTERNAL_DOCUMENT_LOADER_URL",
     "rag.external_document_loader_url",
diff --git a/backend/open_webui/main.py b/backend/open_webui/main.py
index 999993e84..6d02f8014 100644
--- a/backend/open_webui/main.py
+++ b/backend/open_webui/main.py
@@ -212,6 +212,15 @@ from open_webui.config import (
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
+    DATALAB_MARKER_OUTPUT_FORMAT,
+    DATALAB_MARKER_USE_LLM,
     EXTERNAL_DOCUMENT_LOADER_URL,
     EXTERNAL_DOCUMENT_LOADER_API_KEY,
     TIKA_SERVER_URL,
@@ -662,6 +671,15 @@ app.state.config.ENABLE_RAG_HYBRID_SEARCH = ENABLE_RAG_HYBRID_SEARCH
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
+app.state.config.DATALAB_MARKER_OUTPUT_FORMAT = DATALAB_MARKER_OUTPUT_FORMAT
 app.state.config.EXTERNAL_DOCUMENT_LOADER_URL = EXTERNAL_DOCUMENT_LOADER_URL
 app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY = EXTERNAL_DOCUMENT_LOADER_API_KEY
 app.state.config.TIKA_SERVER_URL = TIKA_SERVER_URL
diff --git a/backend/open_webui/retrieval/loaders/datalab_marker_loader.py b/backend/open_webui/retrieval/loaders/datalab_marker_loader.py
new file mode 100644
index 000000000..784c803b8
--- /dev/null
+++ b/backend/open_webui/retrieval/loaders/datalab_marker_loader.py
@@ -0,0 +1,200 @@
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
+        output_format: str = None
+    ):
+        self.file_path = file_path
+        self.api_key = api_key
+        self.langs = langs
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
+        form_data = {
+            "langs": self.langs,
+            "use_llm": str(self.use_llm).lower(),
+            "skip_cache": str(self.skip_cache).lower(),
+            "force_ocr": str(self.force_ocr).lower(),
+            "paginate": str(self.paginate).lower(),
+            "strip_existing_ocr": str(self.strip_existing_ocr).lower(),
+            "disable_image_extraction": str(self.disable_image_extraction).lower(),
+            "output_format": self.output_format,
+        }
+
+        log.info(f"Datalab Marker POST request parameters: {{'filename': '{filename}', 'mime_type': '{mime_type}', **{form_data}}}")
+
+        try:
+            with open(self.file_path, "rb") as f:
+                files = {"file": (filename, f, mime_type)}
+                response = requests.post(url, data=form_data, files=files, headers=headers)
+                response.raise_for_status()
+                result = response.json()
+        except FileNotFoundError:
+            raise HTTPException(status.HTTP_404_NOT_FOUND, detail=f"File not found: {self.file_path}")
+        except requests.HTTPError as e:
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Datalab Marker request failed: {e}")
+        except ValueError as e:
+            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Invalid JSON response: {e}")
+        except Exception as e:
+            raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
+
+        if not result.get("success"):
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Datalab Marker request failed: {result.get('error', 'Unknown error')}")
+
+        check_url = result.get("request_check_url")
+        request_id = result.get("request_id")
+        if not check_url:
+            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail="No request_check_url returned.")
+
+        for _ in range(300):  # Up to 10 minutes
+            time.sleep(2)
+            try:
+                poll_response = requests.get(check_url, headers=headers)
+                poll_response.raise_for_status()
+                poll_result = poll_response.json()
+            except (requests.HTTPError, ValueError) as e:
+                raw_body = poll_response.text
+                log.error(f"Polling error: {e}, response body: {raw_body}")
+                raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Polling failed: {e}")
+
+            status_val = poll_result.get("status")
+            success_val = poll_result.get("success")
+
+            if status_val == "complete":
+                summary = {
+                    k: poll_result.get(k)
+                    for k in ("status", "output_format", "success", "error", "page_count", "total_cost")
+                }
+                log.info(f"Marker processing completed successfully: {json.dumps(summary, indent=2)}")
+                break
+
+            if status_val == "failed" or success_val is False:
+                log.error(f"Marker poll failed full response: {json.dumps(poll_result, indent=2)}")
+                error_msg = poll_result.get("error") or "Marker returned failure without error message"
+                raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Marker processing failed: {error_msg}")
+        else:
+            raise HTTPException(status.HTTP_504_GATEWAY_TIMEOUT, detail="Marker processing timed out")
+
+        if not poll_result.get("success", False):
+            error_msg = poll_result.get("error") or "Unknown processing error"
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Final processing failed: {error_msg}")
+
+        content_key = self.output_format.lower()
+        raw_content = poll_result.get(content_key)
+
+        if content_key == "json":
+            full_text = json.dumps(raw_content, indent=2)
+        elif content_key in {"markdown", "html"}:
+            full_text = str(raw_content).strip()
+        else:
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Unsupported output format: {self.output_format}")
+
+        if not full_text:
+            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail="Datalab Marker returned empty content")
+
+        marker_output_dir = os.path.join("/app/backend/data/uploads", "marker_output")
+        os.makedirs(marker_output_dir, exist_ok=True)
+
+        file_ext_map = {"markdown": "md", "json": "json", "html": "html"}
+        file_ext = file_ext_map.get(content_key, "txt")
+        output_filename = f"{os.path.splitext(filename)[0]}.{file_ext}"
+        output_path = os.path.join(marker_output_dir, output_filename)
+
+        try:
+            with open(output_path, "w", encoding="utf-8") as f:
+                f.write(full_text)
+            log.info(f"Saved Marker output to: {output_path}")
+        except Exception as e:
+            log.warning(f"Failed to write marker output to disk: {e}")
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
+        for k, v in metadata.items():
+            if isinstance(v, (dict, list)):
+                metadata[k] = json.dumps(v)
+            elif v is None:
+                metadata[k] = ""
+
+        return [Document(page_content=full_text, metadata=metadata)]
diff --git a/backend/open_webui/retrieval/loaders/main.py b/backend/open_webui/retrieval/loaders/main.py
index 22397b3b4..286f86a90 100644
--- a/backend/open_webui/retrieval/loaders/main.py
+++ b/backend/open_webui/retrieval/loaders/main.py
@@ -21,7 +21,7 @@ from langchain_community.document_loaders import (
 )
 from langchain_core.documents import Document
 
-
+from open_webui.retrieval.loaders.datalab_marker_loader import DatalabMarkerLoader
 from open_webui.retrieval.loaders.external_document import ExternalDocumentLoader
 from open_webui.retrieval.loaders.mistral import MistralLoader
 
@@ -236,6 +236,23 @@ class Loader:
                     mime_type=file_content_type,
                     extract_images=self.kwargs.get("PDF_EXTRACT_IMAGES"),
                 )
+        elif (
+            self.engine == "datalab_marker"
+            and self.kwargs.get("DATALAB_MARKER_API_KEY")
+            and file_ext in ["pdf", "xls", "xlsx", "ods", "doc", "docx", "odt", "ppt", "pptx", "odp", "html", "epub", "png", "jpeg", "jpg", "webp", "gif", "tiff"]
+        ):
+            loader = DatalabMarkerLoader(
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
         elif self.engine == "docling" and self.kwargs.get("DOCLING_SERVER_URL"):
             if self._is_text_file(file_ext, file_content_type):
                 loader = TextLoader(file_path, autodetect_encoding=True)
diff --git a/backend/open_webui/routers/retrieval.py b/backend/open_webui/routers/retrieval.py
index 98f79c7fe..4026abacd 100644
--- a/backend/open_webui/routers/retrieval.py
+++ b/backend/open_webui/routers/retrieval.py
@@ -353,6 +353,15 @@ async def get_rag_config(request: Request, user=Depends(get_admin_user)):
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
+        "DATALAB_MARKER_OUTPUT_FORMAT": request.app.state.config.DATALAB_MARKER_OUTPUT_FORMAT,
         "EXTERNAL_DOCUMENT_LOADER_URL": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL,
         "EXTERNAL_DOCUMENT_LOADER_API_KEY": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY,
         "TIKA_SERVER_URL": request.app.state.config.TIKA_SERVER_URL,
@@ -500,6 +509,15 @@ class ConfigForm(BaseModel):
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
+    DATALAB_MARKER_OUTPUT_FORMAT: Optional[str] = None
     EXTERNAL_DOCUMENT_LOADER_URL: Optional[str] = None
     EXTERNAL_DOCUMENT_LOADER_API_KEY: Optional[str] = None
 
@@ -599,6 +617,51 @@ async def update_rag_config(
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
+    request.app.state.config.DATALAB_MARKER_OUTPUT_FORMAT = (
+        form_data.DATALAB_MARKER_OUTPUT_FORMAT
+        if form_data.DATALAB_MARKER_OUTPUT_FORMAT is not None
+        else request.app.state.config.DATALAB_MARKER_OUTPUT_FORMAT
+    )
+    request.app.state.config.DATALAB_MARKER_USE_LLM = (
+        form_data.DATALAB_MARKER_USE_LLM
+        if form_data.DATALAB_MARKER_USE_LLM is not None
+        else request.app.state.config.DATALAB_MARKER_USE_LLM
+    )
     request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL = (
         form_data.EXTERNAL_DOCUMENT_LOADER_URL
         if form_data.EXTERNAL_DOCUMENT_LOADER_URL is not None
@@ -853,6 +916,15 @@ async def update_rag_config(
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
+        "DATALAB_MARKER_OUTPUT_FORMAT": request.app.state.config.DATALAB_MARKER_OUTPUT_FORMAT,
         "EXTERNAL_DOCUMENT_LOADER_URL": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL,
         "EXTERNAL_DOCUMENT_LOADER_API_KEY": request.app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY,
         "TIKA_SERVER_URL": request.app.state.config.TIKA_SERVER_URL,
@@ -1178,6 +1250,15 @@ def process_file(
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
+                    DATALAB_MARKER_OUTPUT_FORMAT=request.app.state.config.DATALAB_MARKER_OUTPUT_FORMAT,
                     EXTERNAL_DOCUMENT_LOADER_URL=request.app.state.config.EXTERNAL_DOCUMENT_LOADER_URL,
                     EXTERNAL_DOCUMENT_LOADER_API_KEY=request.app.state.config.EXTERNAL_DOCUMENT_LOADER_API_KEY,
                     TIKA_SERVER_URL=request.app.state.config.TIKA_SERVER_URL,
diff --git a/src/lib/components/admin/Settings/Documents.svelte b/src/lib/components/admin/Settings/Documents.svelte
index 4144004fb..b5fb9b30e 100644
--- a/src/lib/components/admin/Settings/Documents.svelte
+++ b/src/lib/components/admin/Settings/Documents.svelte
@@ -58,6 +58,27 @@
 	};
 
 	let RAGConfig = null;
+	let selectedLanguages: string[] = ['en'];
+	let langsHydrated = false;
+
+	const SUPPORTED_LANGUAGES = {
+		"af": "Afrikaans", "am": "Amharic", "ar": "Arabic", "as": "Assamese", "az": "Azerbaijani", "be": "Belarusian",
+		"bg": "Bulgarian", "bn": "Bengali", "br": "Breton", "bs": "Bosnian", "ca": "Catalan", "cs": "Czech",
+		"cy": "Welsh", "da": "Danish", "de": "German", "el": "Greek", "en": "English", "eo": "Esperanto",
+		"es": "Spanish", "et": "Estonian", "eu": "Basque", "fa": "Persian", "fi": "Finnish", "fr": "French",
+		"fy": "Western Frisian", "ga": "Irish", "gd": "Scottish Gaelic", "gl": "Galician", "gu": "Gujarati",
+		"ha": "Hausa", "he": "Hebrew", "hi": "Hindi", "hr": "Croatian", "hu": "Hungarian", "hy": "Armenian",
+		"id": "Indonesian", "is": "Icelandic", "it": "Italian", "ja": "Japanese", "jv": "Javanese", "ka": "Georgian",
+		"kk": "Kazakh", "km": "Khmer", "kn": "Kannada", "ko": "Korean", "ku": "Kurdish", "ky": "Kyrgyz",
+		"la": "Latin", "lo": "Lao", "lt": "Lithuanian", "lv": "Latvian", "mg": "Malagasy", "mk": "Macedonian",
+		"ml": "Malayalam", "mn": "Mongolian", "mr": "Marathi", "ms": "Malay", "my": "Burmese", "ne": "Nepali",
+		"nl": "Dutch", "no": "Norwegian", "om": "Oromo", "or": "Oriya", "pa": "Punjabi", "pl": "Polish",
+		"ps": "Pashto", "pt": "Portuguese", "ro": "Romanian", "ru": "Russian", "sa": "Sanskrit", "sd": "Sindhi",
+		"si": "Sinhala", "sk": "Slovak", "sl": "Slovenian", "so": "Somali", "sq": "Albanian", "sr": "Serbian",
+		"su": "Sundanese", "sv": "Swedish", "sw": "Swahili", "ta": "Tamil", "te": "Telugu", "th": "Thai",
+		"tl": "Tagalog", "tr": "Turkish", "ug": "Uyghur", "uk": "Ukrainian", "ur": "Urdu", "uz": "Uzbek",
+		"vi": "Vietnamese", "xh": "Xhosa", "yi": "Yiddish", "zh": "Chinese", "_math": "Math"
+	};
 
 	const embeddingModelUpdateHandler = async () => {
 		if (embeddingEngine === '' && embeddingModel.split('/').length - 1 > 1) {
@@ -124,6 +145,10 @@
 	};
 
 	const submitHandler = async () => {
+		if (RAGConfig.CONTENT_EXTRACTION_ENGINE === 'datalab_marker' && !RAGConfig.DATALAB_MARKER_API_KEY) {
+			toast.error($i18n.t('Datalab Marker API Key required.'));
+			return;
+		}
 		if (
 			RAGConfig.CONTENT_EXTRACTION_ENGINE === 'external' &&
 			RAGConfig.EXTERNAL_DOCUMENT_LOADER_URL === ''
@@ -200,8 +225,26 @@
 		const config = await getRAGConfig(localStorage.token);
 		config.ALLOWED_FILE_EXTENSIONS = (config?.ALLOWED_FILE_EXTENSIONS ?? []).join(', ');
 
+		if (!config.DATALAB_MARKER_OUTPUT_FORMAT) {
+			config.DATALAB_MARKER_OUTPUT_FORMAT = 'markdown';
+		}
+
+		if (config.DATALAB_MARKER_LANGS) {
+			selectedLanguages = config.DATALAB_MARKER_LANGS
+				.split(',')
+				.map(code => code.trim())
+				.filter(Boolean);
+		}
+
 		RAGConfig = config;
+		langsHydrated = true;
 	});
+
+	$: if (langsHydrated && RAGConfig) {
+		RAGConfig.DATALAB_MARKER_LANGS = selectedLanguages.length
+			? selectedLanguages.join(',')
+			: 'en';
+	}
 </script>
 
 <ResetUploadDirConfirmDialog
@@ -271,6 +314,7 @@
 									bind:value={RAGConfig.CONTENT_EXTRACTION_ENGINE}
 								>
 									<option value="">{$i18n.t('Default')}</option>
+									<option value="datalab_marker">{ $i18n.t('Datalab Marker API') }</option>
 									<option value="external">{$i18n.t('External')}</option>
 									<option value="tika">{$i18n.t('Tika')}</option>
 									<option value="docling">{$i18n.t('Docling')}</option>
@@ -291,6 +335,108 @@
 									</div>
 								</div>
 							</div>
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
+								{$i18n.t("OCR language(s). Hold Ctrl (Windows) or Cmd (Mac) to select multiple. If no selection defaults to English")}
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
+								<Tooltip content={$i18n.t('Significantly improves accuracy by using an LLM to enhance tables, forms, inline math, and layout detection. Will increase latency. Defaults to True.')} placement="top-start">
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
+							</div>
+							<div class="">
+								<select
+									class="dark:bg-gray-900 w-fit pr-8 rounded-sm px-2 text-xs bg-transparent outline-hidden text-right"
+									bind:value={RAGConfig.DATALAB_MARKER_OUTPUT_FORMAT}
+								>
+									<option value="markdown">{$i18n.t('Markdown')}</option>
+									<option value="json">{$i18n.t('JSON')}</option>
+									<option value="html">{$i18n.t('HTML')}</option>
+								</select>
+							</div>
+							</div>
 						{:else if RAGConfig.CONTENT_EXTRACTION_ENGINE === 'external'}
 							<div class="my-0.5 flex gap-2 pr-2">
 								<input
```

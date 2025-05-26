import os
import time
import requests
import logging
import json
from typing import List, Optional
from langchain_core.documents import Document
from fastapi import HTTPException, status

log = logging.getLogger(__name__)


class DatalabMarkerLoader:
    def __init__(
        self,
        file_path: str,
        api_key: str,
        langs: Optional[str] = None,
        use_llm: bool = False,
        skip_cache: bool = False,
        force_ocr: bool = False,
        paginate: bool = False,
        strip_existing_ocr: bool = False,
        disable_image_extraction: bool = False,
        output_format: str = "markdown"
    ):
        self.file_path = file_path
        self.api_key = api_key
        self.langs = langs or "English"
        self.use_llm = use_llm
        self.skip_cache = skip_cache
        self.force_ocr = force_ocr
        self.paginate = paginate
        self.strip_existing_ocr = strip_existing_ocr
        self.disable_image_extraction = disable_image_extraction
        self.output_format = output_format

    def _get_mime_type(self, filename: str) -> str:
        ext = filename.rsplit(".", 1)[-1].lower()
        mime_map = {
            'pdf': 'application/pdf',
            'xls': 'application/vnd.ms-excel',
            'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'ods': 'application/vnd.oasis.opendocument.spreadsheet',
            'doc': 'application/msword',
            'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'odt': 'application/vnd.oasis.opendocument.text',
            'ppt': 'application/vnd.ms-powerpoint',
            'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            'odp': 'application/vnd.oasis.opendocument.presentation',
            'html': 'text/html',
            'epub': 'application/epub+zip',
            'png': 'image/png',
            'jpeg': 'image/jpeg',
            'jpg': 'image/jpeg',
            'webp': 'image/webp',
            'gif': 'image/gif',
            'tiff': 'image/tiff'
        }
        return mime_map.get(ext, 'application/octet-stream')

    def check_marker_request_status(self, request_id: str) -> dict:
        url = f"https://www.datalab.to/api/v1/marker/{request_id}"
        headers = {"X-Api-Key": self.api_key}
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            result = response.json()
            log.info(f"Marker API status check for request {request_id}: {result}")
            return result
        except requests.HTTPError as e:
            log.error(f"Error checking Marker request status: {e}")
            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Failed to check Marker request: {e}")
        except ValueError as e:
            log.error(f"Invalid JSON checking Marker request: {e}")
            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Invalid JSON: {e}")

    def load(self) -> List[Document]:
        url = "https://www.datalab.to/api/v1/marker"
        filename = os.path.basename(self.file_path)
        mime_type = self._get_mime_type(filename)
        headers = {"X-Api-Key": self.api_key}

        form_data = {}

        if self.langs:
            form_data['langs'] = (None, self.langs)
        form_data['use_llm'] = (None, str(self.use_llm).lower())
        form_data['skip_cache'] = (None, str(self.skip_cache).lower())
        form_data['force_ocr'] = (None, str(self.force_ocr).lower())
        form_data['paginate'] = (None, str(self.paginate).lower())
        form_data['strip_existing_ocr'] = (None, str(self.strip_existing_ocr).lower())
        form_data['disable_image_extraction'] = (None, str(self.disable_image_extraction).lower())
        form_data['output_format'] = (None, self.output_format)

        request_params = {
            'url': url,
            'filename': filename,
            'mime_type': mime_type,
            'langs': self.langs,
            'use_llm': self.use_llm,
            'skip_cache': self.skip_cache,
            'force_ocr': self.force_ocr,
            'paginate': self.paginate,
            'strip_existing_ocr': self.strip_existing_ocr,
            'disable_image_extraction': self.disable_image_extraction,
            'output_format': self.output_format,
        }
        log.info(f"Datalab Marker POST request parameters: {request_params}")

        try:
            with open(self.file_path, "rb") as f:
                form_data['file'] = (filename, f, mime_type)
                response = requests.post(url, files=form_data, headers=headers)
        except FileNotFoundError:
            log.error(f"File not found: {self.file_path}")
            raise HTTPException(status.HTTP_404_NOT_FOUND, detail=f"File not found: {self.file_path}")
        except Exception as e:
            log.error(f"Error reading file: {e}")
            raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error reading file: {e}")

        try:
            response.raise_for_status()
            result = response.json()
        except requests.HTTPError as e:
            log.error(f"Datalab Marker request failed: {e}")
            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Datalab Marker request failed: {e}")
        except ValueError as e:
            log.error(f"Invalid JSON response: {e}")
            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Invalid JSON response: {e}")

        if not result.get("success", False):
            error_msg = result.get("error") or "Unknown error"
            log.error(f"Datalab Marker request failed: {error_msg}")
            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Datalab Marker request failed: {error_msg}")

        check_url = result.get("request_check_url")
        request_id = result.get("request_id")
        if not check_url:
            raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail="No request_check_url returned.")

        # Polling loop
        for _ in range(300):  # Up to 10 minutes
            time.sleep(2)
            try:
                poll_response = requests.get(check_url, headers=headers)
                poll_response.raise_for_status()
                poll_result = poll_response.json()
            except (requests.HTTPError, ValueError) as e:
                log.error(f"Polling error: {e}")
                raise HTTPException(status.HTTP_502_BAD_GATEWAY, detail=f"Polling failed: {e}")

            if poll_result.get("status") == "complete":
                break
            if not poll_result.get("success", True):
                error_msg = poll_result.get("error") or "Unknown processing error"
                raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Marker processing failed: {error_msg}")
        else:
            raise HTTPException(status.HTTP_504_GATEWAY_TIMEOUT, detail="Marker processing timed out")

        if not poll_result.get("success", False):
            error_msg = poll_result.get("error") or "Unknown processing error"
            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail=f"Final processing failed: {error_msg}")

        content_key = self.output_format.lower()
        if content_key not in poll_result:
            content_key = "markdown"
        full_text = poll_result.get(content_key, "")

        if not full_text.strip():
            raise HTTPException(status.HTTP_400_BAD_REQUEST, detail="Datalab Marker returned empty content")

        metadata = {
            "source": filename,
            "output_format": poll_result.get("output_format", self.output_format),
            "page_count": poll_result.get("page_count", 0),
            "processed_with_llm": self.use_llm,
            "request_id": request_id or "",
        }

        images = poll_result.get("images", {})
        if images:
            metadata["image_count"] = len(images)
            metadata["images"] = json.dumps(list(images.keys()))

        for key, value in metadata.items():
            if value is None:
                metadata[key] = ""
            elif isinstance(value, (list, dict)):
                metadata[key] = json.dumps(value)

        #log.info(f"Processed {filename}: {metadata['page_count']} pages, {len(full_text)} characters.")
        return [Document(page_content=full_text, metadata=metadata)]

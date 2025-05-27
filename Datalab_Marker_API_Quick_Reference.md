# Datalab Marker API - Quick Reference Card

## Setup Checklist
- [ ] Admin access to OpenWebUI
- [ ] Datalab.to account created
- [ ] API key generated from datalab.to
- [ ] Sufficient credits in account

## Configuration Steps
1. **Admin Settings** → **Documents**
2. **Content Extraction Engine** → **"Datalab Marker API"**
3. Enter **API Key**
4. Select **Languages** (Ctrl/Cmd + click for multiple)
5. Choose **Output Format** (Markdown/JSON/HTML)
6. **Save**

## Supported File Types
| Category | Extensions |
|----------|------------|
| **Documents** | .pdf, .doc, .docx, .odt |
| **Spreadsheets** | .xls, .xlsx, .ods |
| **Presentations** | .ppt, .pptx, .odp |
| **Web/E-books** | .html, .epub |
| **Images** | .png, .jpg, .jpeg, .webp, .gif, .tiff |

## Key Settings

### Essential
- **API Key**: Required for authentication
- **Languages**: Select document language(s) for better OCR
- **Output Format**: Markdown (default), JSON, or HTML

### Advanced
- **Use LLM**: ✅ Enable for complex documents (better accuracy, slower)
- **Force OCR**: Enable for PDFs with poor embedded text
- **Paginate**: Add page numbers and separators
- **Skip Cache**: Force re-processing
- **Strip Existing OCR**: Remove and redo OCR text
- **Disable Image Extraction**: Text-only processing

## Processing Times
- **Simple PDFs**: 30 seconds - 2 minutes
- **Complex Documents**: 2-10 minutes
- **Factors**: File size, images, LLM usage, API load

## Limits
- **File Size**: 200MB maximum
- **Rate Limit**: 200 requests per 60 seconds
- **Concurrent**: 200 simultaneous requests
- **Timeout**: 10 minutes maximum processing

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| **"API Key required"** | Verify valid key from datalab.to |
| **Poor OCR results** | Check language selection, enable Force OCR |
| **Processing timeout** | Try smaller files, disable LLM |
| **Empty results** | Check file format, enable Force OCR |

## Best Practices
1. **Start with defaults** and adjust as needed
2. **Select correct languages** for your documents
3. **Enable LLM** for complex layouts and tables
4. **Test with small files** before processing large batches
5. **Monitor credit usage** to avoid unexpected charges

## Quick Troubleshooting
1. Check API key validity
2. Verify file format is supported
3. Ensure file isn't corrupted or password-protected
4. Try different output format
5. Check system logs for detailed errors

## Support
- **Technical Issues**: support@datalab.to
- **API Status**: Check datalab.to
- **Documentation**: Full user guide available
- **Community**: OpenWebUI forums

---
*Keep this reference handy while using the Datalab Marker API feature*

# Datalab Marker API Integration - User Guide

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Getting Started](#getting-started)
4. [Configuration Guide](#configuration-guide)
5. [Usage Instructions](#usage-instructions)
6. [Advanced Settings](#advanced-settings)
7. [Supported File Formats](#supported-file-formats)
8. [Troubleshooting](#troubleshooting)
9. [Technical Details](#technical-details)
10. [Best Practices](#best-practices)

---

## Overview

The Datalab Marker API integration in OpenWebUI provides powerful document processing capabilities using advanced OCR, PDF to markdown conversion, and table recognition technologies. This feature leverages the Surya and Marker projects to extract and convert content from various document formats with high accuracy.

### Key Features
- **Advanced OCR**: High-quality optical character recognition for scanned documents
- **Document Conversion**: Convert PDFs, Office documents, and other formats to markdown, JSON, or HTML
- **Table Recognition**: Intelligent table detection and extraction
- **Multi-language Support**: OCR support for 60+ languages
- **LLM Enhancement**: Optional AI-powered processing for improved accuracy
- **Flexible Output**: Choose from markdown, JSON, or HTML output formats

### Benefits
- **Improved Accuracy**: Superior text extraction compared to traditional OCR tools
- **Time Saving**: Automated document processing and conversion
- **Versatile Input**: Support for multiple file formats including PDFs, Office documents, and images
- **Customizable Processing**: Fine-tune extraction settings for specific use cases
- **Integration Ready**: Seamlessly integrates with OpenWebUI's document processing pipeline

---

## Prerequisites

Before using the Datalab Marker API feature, you need:

1. **OpenWebUI Admin Access**: You must have administrator privileges in your OpenWebUI instance
2. **Datalab.to Account**: A registered account at [datalab.to](https://datalab.to)
3. **API Key**: A valid Datalab Marker API key from your account
4. **Credits**: Sufficient credits in your Datalab account for document processing

### Getting Your API Key

1. Visit [datalab.to](https://datalab.to) and create an account or log in
2. Navigate to your account dashboard
3. Go to the API Keys section
4. Generate a new API key for Marker API access
5. Copy the API key for use in OpenWebUI configuration

---

## Getting Started

### Step 1: Access Admin Settings

1. Log into your OpenWebUI instance with administrator credentials
2. Navigate to **Admin Settings** from the main menu
3. Click on the **Documents** tab/page

### Step 2: Select Content Extraction Engine

1. In the Documents settings, locate the **Content Extraction Engine** dropdown
2. Select **"Datalab Marker API"** from the available options
3. The configuration panel for Datalab Marker will appear below

### Step 3: Enter API Key

1. In the **API Key** field, paste your Datalab Marker API key
2. This field is marked as sensitive and will be masked for security

### Step 4: Configure Basic Settings

1. **Language Selection**: Choose the primary language(s) for OCR processing
   - Hold Ctrl (Windows) or Cmd (Mac) to select multiple languages
   - If no selection is made, English will be used by default

2. **Output Format**: Select your preferred output format:
   - **Markdown** (recommended for most use cases)
   - **JSON** (for structured data processing)
   - **HTML** (for web-based applications)

### Step 5: Save Configuration

1. Click the **Save** button at the bottom of the settings panel
2. Wait for the confirmation message indicating successful configuration
3. The feature is now ready to use

---

## Configuration Guide

### Required Settings

#### API Key
- **Purpose**: Authenticates your requests to the Datalab Marker API
- **Format**: Alphanumeric string provided by Datalab.to
- **Security**: Stored securely and masked in the interface
- **Validation**: The system will validate the key when saving settings

#### Language Selection
- **Purpose**: Specifies the language(s) present in your documents for OCR processing
- **Options**: 60+ supported languages including:
  - **English** (en) - Default if no selection made
  - **Spanish** (es), **French** (fr), **German** (de)
  - **Chinese** (zh), **Japanese** (ja), **Korean** (ko)
  - **Arabic** (ar), **Hindi** (hi), **Russian** (ru)
  - **Math** (_math) - For mathematical notation
- **Multi-language**: Select multiple languages for documents containing mixed content
- **Impact**: Proper language selection significantly improves OCR accuracy

### Optional Settings

#### Output Format
- **Markdown** (Default): Clean, readable format ideal for documentation
- **JSON**: Structured format with detailed metadata and formatting information
- **HTML**: Web-ready format with preserved styling and layout

---

## Usage Instructions

### Processing Documents

Once configured, the Datalab Marker API will automatically process supported documents when you:

1. **Upload Files**: Use the standard file upload feature in OpenWebUI
2. **Drag and Drop**: Drop supported files into the chat interface
3. **Knowledge Base**: Add documents to your knowledge base for RAG processing

### Processing Workflow

1. **File Upload**: User uploads a supported document
2. **API Submission**: OpenWebUI sends the file to Datalab Marker API
3. **Processing**: Datalab processes the document (may take 30 seconds to several minutes)
4. **Polling**: System checks processing status every 2 seconds
5. **Completion**: Processed content is returned and integrated into OpenWebUI
6. **Storage**: Converted content is saved locally for future reference

### Processing Time

- **Simple PDFs**: 30 seconds to 2 minutes
- **Complex Documents**: 2-10 minutes depending on:
  - File size and page count
  - Image content and complexity
  - Whether LLM enhancement is enabled
  - Current API load

### Status Monitoring

The system provides processing status updates:
- **Submitted**: File sent to Datalab API
- **Processing**: Document being analyzed and converted
- **Complete**: Processing finished successfully
- **Failed**: Error occurred (check logs for details)

---

## Advanced Settings

### Use LLM Enhancement
- **Purpose**: Employs AI to improve accuracy of tables, forms, inline math, and layout detection
- **Benefits**: Significantly better results for complex documents
- **Trade-offs**: Increased processing time and cost
- **Recommendation**: Enable for important documents or complex layouts
- **Default**: Enabled (recommended)

### Skip Cache
- **Purpose**: Forces re-processing even if document was previously processed
- **Use Cases**: 
  - Testing different settings
  - When previous results were unsatisfactory
  - Ensuring latest processing algorithms are used
- **Impact**: Increases processing time and costs
- **Default**: Disabled

### Force OCR
- **Purpose**: Applies OCR to all pages, ignoring existing text in PDFs
- **When to Use**: 
  - PDFs with poor quality embedded text
  - Scanned documents saved as PDFs
  - When default text extraction produces poor results
- **Caution**: May reduce quality for PDFs with good embedded text
- **Default**: Disabled

### Paginate Output
- **Purpose**: Adds page separators and numbers to the output
- **Format**: Horizontal rules (---) with page numbers
- **Benefits**: Maintains document structure and page references
- **Use Cases**: Academic papers, legal documents, reports
- **Default**: Disabled

### Strip Existing OCR
- **Purpose**: Removes existing OCR text and re-runs OCR processing
- **When to Use**: Documents processed with low-quality OCR tools
- **Interaction**: Ignored if Force OCR is enabled
- **Impact**: Increases processing time
- **Default**: Disabled

### Disable Image Extraction
- **Purpose**: Prevents extraction of images from documents
- **LLM Interaction**: When Use LLM is enabled, images are converted to text descriptions instead
- **Use Cases**: 
  - Text-only processing requirements
  - Reducing output size
  - Privacy concerns with images
- **Default**: Disabled (images are extracted)

---

## Supported File Formats

### Document Formats
- **PDF** (.pdf) - Portable Document Format
- **Microsoft Word** (.doc, .docx) - Word documents
- **OpenDocument Text** (.odt) - Open standard text documents
- **Microsoft Excel** (.xls, .xlsx) - Spreadsheets
- **OpenDocument Spreadsheet** (.ods) - Open standard spreadsheets
- **Microsoft PowerPoint** (.ppt, .pptx) - Presentations
- **OpenDocument Presentation** (.odp) - Open standard presentations

### Web and E-book Formats
- **HTML** (.html) - Web pages
- **EPUB** (.epub) - E-book format

### Image Formats
- **PNG** (.png) - Portable Network Graphics
- **JPEG** (.jpg, .jpeg) - Joint Photographic Experts Group
- **WebP** (.webp) - Modern web image format
- **GIF** (.gif) - Graphics Interchange Format
- **TIFF** (.tiff) - Tagged Image File Format

### File Size Limits
- **Maximum Size**: 200MB per file
- **Recommendation**: For larger files, consider splitting into smaller chunks
- **Contact**: Reach out to support@datalab.to for higher limits if needed

---

## Troubleshooting

### Common Issues

#### "Datalab Marker API Key required" Error
- **Cause**: No API key entered or invalid key
- **Solution**: 
  1. Verify you have a valid API key from datalab.to
  2. Check for extra spaces or characters when pasting
  3. Ensure the key hasn't expired or been revoked

#### Processing Timeout
- **Cause**: Document processing took longer than 10 minutes
- **Solutions**:
  1. Try processing smaller documents
  2. Disable LLM enhancement for faster processing
  3. Check if the document is corrupted
  4. Contact support if issue persists

#### Poor OCR Results
- **Causes**: Incorrect language selection, poor document quality
- **Solutions**:
  1. Verify correct language(s) are selected
  2. Enable "Force OCR" for PDFs with embedded text issues
  3. Enable "Use LLM" for better accuracy
  4. Try "Strip Existing OCR" for previously processed documents

#### Empty or Incomplete Results
- **Causes**: Document format issues, processing errors
- **Solutions**:
  1. Verify file format is supported
  2. Check if document is password-protected or corrupted
  3. Try different output format (markdown vs JSON vs HTML)
  4. Enable "Force OCR" for scanned documents

### Error Messages

#### "Failed to check Marker request"
- **Meaning**: Communication error with Datalab API
- **Actions**: Check internet connection, verify API key, try again later

#### "Invalid JSON response"
- **Meaning**: Unexpected response from API
- **Actions**: Check API status, contact support if persistent

#### "File not found"
- **Meaning**: Uploaded file couldn't be accessed
- **Actions**: Re-upload the file, check file permissions

#### "Processing failed"
- **Meaning**: Document processing encountered an error
- **Actions**: Check document format, try different settings, contact support

### Getting Help

1. **Check Logs**: Admin users can check system logs for detailed error information
2. **API Status**: Visit [datalab.to](https://datalab.to) to check service status
3. **Support**: Contact support@datalab.to for technical issues
4. **Community**: Check OpenWebUI community forums for user discussions

---

## Technical Details

### API Endpoints
- **Base URL**: https://www.datalab.to/api/v1/marker
- **Method**: POST (multipart/form-data)
- **Authentication**: X-Api-Key header

### Rate Limits
- **Request Limit**: 200 requests per 60 seconds
- **Concurrent Limit**: Maximum 200 concurrent requests
- **Error Code**: 429 (Too Many Requests) when limits exceeded
- **Higher Limits**: Contact support@datalab.to for increased limits

### Billing Information
- **Pricing Model**: Per-page processing with credit system
- **Initial Credits**: Included with your plan
- **Overage Billing**: Automatic billing for usage above initial credits
- **Cost Control**: Set billing limits per API key to avoid unexpected charges
- **Pricing Details**: Check the plans page at datalab.to for current rates

### Data Retention
- **Processing Results**: Deleted from Datalab servers 1 hour after completion
- **Local Storage**: Processed content saved in OpenWebUI's marker_output directory
- **Recommendation**: Download important results promptly

### Security Considerations
- **API Key Protection**: Keys are stored securely and masked in the interface
- **Data Transmission**: All communication uses HTTPS encryption
- **Data Privacy**: Documents are processed on Datalab's secure servers
- **Retention Policy**: Temporary storage only, automatic deletion after processing

---

## Best Practices

### Document Preparation
1. **Quality Matters**: Higher quality source documents produce better results
2. **Language Consistency**: Select appropriate languages for your content
3. **File Size**: Keep files under 200MB for optimal processing
4. **Format Selection**: Use native formats when possible (e.g., .docx vs scanned PDF)

### Configuration Optimization
1. **Start Simple**: Begin with default settings and adjust as needed
2. **Test Settings**: Use small test documents to evaluate different configurations
3. **Language Selection**: Be specific about languages present in your documents
4. **LLM Usage**: Enable for complex documents, disable for simple text extraction

### Performance Tips
1. **Batch Processing**: Process multiple documents during off-peak hours
2. **Cache Utilization**: Don't skip cache unless necessary
3. **Format Choice**: Markdown is typically fastest to process
4. **Monitoring**: Keep track of processing times and adjust settings accordingly

### Cost Management
1. **Set Limits**: Configure billing limits on your API keys
2. **Monitor Usage**: Regularly check your credit consumption
3. **Optimize Settings**: Disable unnecessary features to reduce costs
4. **Plan Ahead**: Purchase additional credits before running large processing jobs

### Quality Assurance
1. **Review Results**: Always review processed content for accuracy
2. **Compare Formats**: Try different output formats for complex documents
3. **Iterative Improvement**: Adjust settings based on results
4. **Backup Originals**: Keep original documents for reference

---

## Conclusion

The Datalab Marker API integration provides powerful document processing capabilities that can significantly enhance your OpenWebUI experience. By following this guide and experimenting with different settings, you can achieve optimal results for your specific document processing needs.

For additional support or questions, refer to the troubleshooting section or contact the Datalab support team at support@datalab.to.

---

*Last Updated: [Current Date]*
*Version: 1.0*

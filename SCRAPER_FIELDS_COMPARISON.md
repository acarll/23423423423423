# Scraper Fields Comparison - Before vs After Update

## ✅ All Required Fields Now Extracted

### Field Mapping

| Required Field (Polish) | Field Name (English) | Status | Stored In |
|------------------------|---------------------|--------|-----------|
| 1. Numer ogłoszenia | Tender ID | ✅ | `tender_id`, `tender_number` |
| 2. Kategoria ogłoszenia | Category | ✅ | `category` (full text) + `cpv_code` |
| 3. Data dodania | Date added | ✅ | `published_date` |
| 4. Przedmiot ogłoszenia | Subject/Title | ✅ | `title` |
| 5. Organizator | Organization | ✅ | `client` |
| 6. Adres | Address | ✅ | `address`, `contact_details.address` |
| 7. Województwo/powiat | Region/District | ✅ | `region` |
| 8. Państwo | Country | ✅ | `country`, `contact_details.country` |
| 9. Telefon/fax | Phone/Fax | ✅ | `phone`, `fax`, `contact_details.phone`, `contact_details.fax` |
| 10. Strona www | Website URL | ✅ | `website`, `contact_details.website` |
| 11. Opis | Full description | ✅ | `description` |
| 12. Miejsce i termin składania ofert | Submission details | ✅ | `submission_details` |
| 13. Termin składania | Deadline | ✅ | `deadline` |
| 14. Wymagania | Requirements | ✅ | `requirements` (full text) |
| 15. Numer dokumentu | Document number | ✅ | `document_number` |
| 16. Źródło | Source | ✅ | `source_info` |
| 17. Załączniki | Attachments | ✅ | `documents` (array) |

## Storage Structure

### Main Fields (Database Columns)
- `title`, `description`, `client`, `budget`, `currency`
- `region`, `deadline`, `published_date`
- `cpv_code`, `type`, `branch`
- `documents` (JSONB array)
- `contact_details` (JSONB object)
- `raw_data` (JSONB - contains ALL fields)

### Additional Fields (in raw_data JSONB)
All extra fields are stored in `raw_data` JSONB for complete information:
- `tender_id` - Numer ogłoszenia
- `category` - Full category text
- `address` - Full address
- `country` - Country
- `phone` - Phone number
- `fax` - Fax number
- `website` - Website URL
- `submission_details` - Submission location and details
- `requirements` - Full requirements text
- `document_number` - Document number
- `source_info` - Source information

## Authentication

✅ **Login functionality added**
- Username: 30672483 (from env or default)
- Password: UjagOBe3m (from env or default)
- Session management with 30-minute timeout
- Automatic re-authentication on 401/403 errors

## Testing Checklist

- [ ] Test login functionality
- [ ] Test extraction of all 17 fields
- [ ] Verify data stored in database correctly
- [ ] Check raw_data contains all fields
- [ ] Test with real tender page
- [ ] Verify authentication persists across requests


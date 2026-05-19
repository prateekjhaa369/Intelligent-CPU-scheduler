import sys
import zipfile
import xml.etree.ElementTree as ET

def extract_docx(path):
    with zipfile.ZipFile(path) as z:
        with z.open('word/document.xml') as f:
            tree = ET.parse(f)
            root = tree.getroot()
            # Word XML namespace
            ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
            paragraphs = []
            for para in root.findall('.//w:p', ns):
                texts = [t.text for t in para.findall('.//w:t', ns) if t is not None]
                if texts:
                    paragraphs.append(''.join(texts))
            return '\n\n'.join(paragraphs)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: extract_docx.py <file.docx>')
        sys.exit(2)
    path = sys.argv[1]
    try:
        txt = extract_docx(path)
        print(txt)
    except Exception as e:
        print('Error extracting', e)
        sys.exit(1)

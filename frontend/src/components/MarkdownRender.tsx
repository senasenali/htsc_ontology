import React from 'react';

// ── Helpers ──────────────────────────────────────────────────────────────────────

function escapeHtml(text: string): string {
  return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function renderInline(text: string): string {
  return text
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/`([^`]+)`/g, '<code class="bg-slate-100 text-blue-700 px-1.5 py-0.5 rounded text-sm font-mono">$1</code>')
    .replace(/\n/g, '<br/>');
}

function renderTable(block: string): string {
  const rows = block.trim().split('\n');
  if (rows.length < 2) return renderInline(block);

  const headers = rows[0].split('|').filter(c => c.trim());
  const dataRows = rows.slice(2);

  let html = '<div class="overflow-x-auto my-2"><table class="min-w-full text-sm border-collapse border border-slate-300">';
  html += '<thead><tr>';
  for (const h of headers) {
    html += `<th class="border border-slate-300 bg-slate-100 px-3 py-1.5 text-left font-semibold">${renderInline(h.trim())}</th>`;
  }
  html += '</tr></thead><tbody>';
  for (const row of dataRows) {
    if (!row.trim() || row.trim().startsWith('---')) continue;
    const cells = row.split('|').filter(c => c.trim());
    html += '<tr>';
    for (const cell of cells) {
      html += `<td class="border border-slate-300 px-3 py-1.5">${renderInline(cell.trim())}</td>`;
    }
    html += '</tr>';
  }
  html += '</tbody></table></div>';
  return html;
}

// ── Component ────────────────────────────────────────────────────────────────────

export default function MarkdownRender({ content }: { content: string }) {
  const codeBlocks: string[] = [];
  let processed = content.replace(/```(\w*)\n([\s\S]*?)```/g, (_, _lang, code) => {
    const idx = codeBlocks.length;
    codeBlocks.push(`<pre class="bg-slate-900 text-green-400 p-3 rounded-lg my-2 text-sm overflow-x-auto"><code>${escapeHtml(code)}</code></pre>`);
    return `%%CODEBLOCK_${idx}%%`;
  });

  const blocks = processed.split('\n\n');
  const htmlBlocks = blocks.map(block => {
    block = block.replace(/%%CODEBLOCK_(\d+)%%/g, (_, idx) => codeBlocks[parseInt(idx)]);

    const trimmed = block.trim();
    if (!trimmed) return '';
    if (trimmed.startsWith('%%CODEBLOCK_')) return trimmed;

    if (/^---+$/.test(trimmed)) return '<hr class="my-3 border-slate-300" />';

    const headingMatch = trimmed.match(/^(#{1,3})\s+(.+)$/m);
    if (headingMatch) {
      const level = headingMatch[1].length;
      const text = headingMatch[2];
      const Tag = `h${level}` as keyof JSX.IntrinsicElements;
      return `<${Tag} class="text-${level === 1 ? 'lg' : 'base'} font-bold text-slate-900 mt-4 mb-2">${renderInline(text)}</${Tag}>`;
    }

    if (/^- .+/m.test(trimmed)) {
      const items = trimmed.split('\n').filter(l => l.trim().startsWith('- '));
      return '<ul class="list-disc pl-5 my-2 space-y-1">' +
        items.map(item => `<li class="text-slate-700">${renderInline(item.replace(/^- /, ''))}</li>`).join('') +
        '</ul>';
    }

    if (trimmed.startsWith('|')) return renderTable(trimmed);

    return `<p class="text-slate-700 mb-2">${renderInline(trimmed)}</p>`;
  });

  const finalHtml = htmlBlocks.filter(Boolean).join('\n');

  return (
    <div className="text-sm leading-relaxed" dangerouslySetInnerHTML={{ __html: finalHtml }} />
  );
}

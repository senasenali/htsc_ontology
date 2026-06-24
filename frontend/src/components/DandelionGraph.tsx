import React, { useEffect, useRef, useState } from 'react';
import * as d3 from 'd3';
import { ObjectType, LinkType } from '@/src/store/ontologyStore';

interface DandelionGraphProps {
  center: ObjectType;
  relatedLinks: LinkType[];
  allObjects: ObjectType[];
  onNodeClick?: (ot: ObjectType) => void;
}

interface GraphNode extends d3.SimulationNodeDatum {
  id: string;
  name: string;
  ot: ObjectType;
  direction: 'upstream' | 'downstream';
  links: LinkType[];
  r: number;
  color: string;
}

interface GraphLink extends d3.SimulationLinkDatum<GraphNode> {
  source: string | GraphNode;
  target: string | GraphNode;
  link: LinkType;
  color: string;
}

const CENTER_R = 56;
const PETAL_R = 38;
const ORBIT_R = 240;

const UPSTREAM_COLOR = '#3b82f6';   // blue-500
const DOWNSTREAM_COLOR = '#10b981'; // emerald-500
const CENTER_COLOR = '#4f46e5';     // indigo-600

function truncateText(text: string, maxLen = 5): string {
  if (text.length <= maxLen) return text;
  return text.slice(0, maxLen) + '…';
}

function buildGraphData(
  center: ObjectType,
  relatedLinks: LinkType[],
  allObjects: ObjectType[]
): { nodes: GraphNode[]; links: GraphLink[] } {
  const otMap = new Map(allObjects.map(o => [o.id, o]));
  const petalMap = new Map<string, GraphNode>();

  const centerNode: GraphNode = {
    id: center.id,
    name: center.name,
    ot: center,
    direction: 'downstream',
    links: [],
    r: CENTER_R,
    color: CENTER_COLOR,
    fx: 0,
    fy: 0,
  };

  const links: GraphLink[] = [];

  for (const lt of relatedLinks) {
    if (lt.sourceObjectId === center.id) {
      if (!petalMap.has(lt.targetObjectId)) {
        const ot = otMap.get(lt.targetObjectId);
        petalMap.set(lt.targetObjectId, {
          id: lt.targetObjectId,
          name: ot?.name || lt.targetObjectId,
          ot: ot || {
            id: lt.targetObjectId,
            name: lt.targetObjectId,
            description: '',
            icon: '',
            backingDataset: '',
            properties: [],
          },
          direction: 'downstream',
          links: [],
          r: PETAL_R,
          color: DOWNSTREAM_COLOR,
        });
      }
      petalMap.get(lt.targetObjectId)!.links.push(lt);
      links.push({
        source: center.id,
        target: lt.targetObjectId,
        link: lt,
        color: DOWNSTREAM_COLOR,
      });
    } else if (lt.targetObjectId === center.id) {
      if (!petalMap.has(lt.sourceObjectId)) {
        const ot = otMap.get(lt.sourceObjectId);
        petalMap.set(lt.sourceObjectId, {
          id: lt.sourceObjectId,
          name: ot?.name || lt.sourceObjectId,
          ot: ot || {
            id: lt.sourceObjectId,
            name: lt.sourceObjectId,
            description: '',
            icon: '',
            backingDataset: '',
            properties: [],
          },
          direction: 'upstream',
          links: [],
          r: PETAL_R,
          color: UPSTREAM_COLOR,
        });
      }
      petalMap.get(lt.sourceObjectId)!.links.push(lt);
      links.push({
        source: lt.sourceObjectId,
        target: center.id,
        link: lt,
        color: UPSTREAM_COLOR,
      });
    }
  }

  return {
    nodes: [centerNode, ...Array.from(petalMap.values())],
    links,
  };
}

export const DandelionGraph: React.FC<DandelionGraphProps> = ({
  center,
  relatedLinks,
  allObjects,
  onNodeClick,
}) => {
  const containerRef = useRef<HTMLDivElement>(null);
  const svgRef = useRef<SVGSVGElement>(null);
  const [tooltip, setTooltip] = useState<{ x: number; y: number; content: React.ReactNode } | null>(null);
  const [dimensions, setDimensions] = useState({ width: 800, height: 600 });

  // 监听容器尺寸变化
  useEffect(() => {
    if (!containerRef.current) return;

    const observer = new ResizeObserver(entries => {
      for (const entry of entries) {
        const { width, height } = entry.contentRect;
        setDimensions({ width: Math.max(width, 400), height: Math.max(height, 400) });
      }
    });

    observer.observe(containerRef.current);
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    if (!svgRef.current || dimensions.width === 0) return;

    const svg = d3.select(svgRef.current);
    svg.selectAll('*').remove();

    const { width, height } = dimensions;
    const centerX = width / 2;
    const centerY = height / 2;

    svg.attr('width', width).attr('height', height);

    // 背景装饰：柔和的径向渐变
    const defs = svg.append('defs');

    const centerGradient = defs.append('radialGradient')
      .attr('id', 'center-gradient')
      .attr('cx', '50%')
      .attr('cy', '50%')
      .attr('r', '50%');
    centerGradient.append('stop').attr('offset', '0%').attr('stop-color', '#818cf8');
    centerGradient.append('stop').attr('offset', '100%').attr('stop-color', '#4f46e5');

    const upstreamGradient = defs.append('radialGradient')
      .attr('id', 'upstream-gradient')
      .attr('cx', '30%')
      .attr('cy', '30%')
      .attr('r', '70%');
    upstreamGradient.append('stop').attr('offset', '0%').attr('stop-color', '#dbeafe');
    upstreamGradient.append('stop').attr('offset', '100%').attr('stop-color', '#bfdbfe');

    const downstreamGradient = defs.append('radialGradient')
      .attr('id', 'downstream-gradient')
      .attr('cx', '30%')
      .attr('cy', '30%')
      .attr('r', '70%');
    downstreamGradient.append('stop').attr('offset', '0%').attr('stop-color', '#d1fae5');
    downstreamGradient.append('stop').attr('offset', '100%').attr('stop-color', '#a7f3d0');

    // 背景渐变
    const bgGradient = defs.append('radialGradient')
      .attr('id', 'bg-gradient')
      .attr('cx', '50%')
      .attr('cy', '50%')
      .attr('r', '50%');
    bgGradient.append('stop').attr('offset', '0%').attr('stop-color', '#f8fafc');
    bgGradient.append('stop').attr('offset', '70%').attr('stop-color', '#f1f5f9');
    bgGradient.append('stop').attr('offset', '100%').attr('stop-color', '#e2e8f0');

    // 箭头标记
    const arrowSize = 8;
    ['upstream', 'downstream'].forEach(dir => {
      const color = dir === 'upstream' ? UPSTREAM_COLOR : DOWNSTREAM_COLOR;
      defs.append('marker')
        .attr('id', `arrow-${dir}`)
        .attr('markerWidth', arrowSize)
        .attr('markerHeight', arrowSize)
        .attr('refX', arrowSize - 1)
        .attr('refY', arrowSize / 2)
        .attr('orient', 'auto')
        .append('polygon')
        .attr('points', `0,0 ${arrowSize},${arrowSize / 2} 0,${arrowSize}`)
        .attr('fill', color);
    });

    // 阴影滤镜
    const filter = defs.append('filter')
      .attr('id', 'soft-shadow')
      .attr('x', '-50%')
      .attr('y', '-50%')
      .attr('width', '200%')
      .attr('height', '200%');
    filter.append('feDropShadow')
      .attr('dx', 0)
      .attr('dy', 2)
      .attr('stdDeviation', 3)
      .attr('flood-color', '#000000')
      .attr('flood-opacity', 0.12);

    const g = svg.append('g');

    // 背景装饰圆
    g.append('circle')
      .attr('r', ORBIT_R + 80)
      .attr('fill', 'url(#bg-gradient)')
      .attr('opacity', 0.5);

    // 中心脉冲动画
    const pulseCircle = g.append('circle')
      .attr('r', CENTER_R)
      .attr('fill', CENTER_COLOR)
      .attr('opacity', 0.2);

    function pulse() {
      pulseCircle
        .transition()
        .duration(1500)
        .ease(d3.easeCubicOut)
        .attr('r', CENTER_R + 30)
        .attr('opacity', 0)
        .on('end', () => {
          pulseCircle.attr('r', CENTER_R).attr('opacity', 0.2);
          pulse();
        });
    }
    pulse();

    // 缩放行为
    const zoom = d3.zoom<SVGSVGElement, unknown>()
      .scaleExtent([0.5, 3])
      .on('zoom', (event) => {
        g.attr('transform', event.transform);
      });

    svg.call(zoom);
    // 初始居中
    const initialTransform = d3.zoomIdentity.translate(centerX, centerY).scale(1);
    svg.call(zoom.transform, initialTransform);

    const { nodes, links } = buildGraphData(center, relatedLinks, allObjects);

    // 力导向模拟
    const simulation = d3.forceSimulation<GraphNode>(nodes)
      .force('charge', d3.forceManyBody<GraphNode>().strength(-400))
      .force('collide', d3.forceCollide<GraphNode>().radius(d => d.r + 12).strength(0.7))
      .force('radial', d3.forceRadial<GraphNode>(d => d.id === center.id ? 0 : ORBIT_R, 0, 0).strength(0.6))
      .force('link', d3.forceLink<GraphNode, GraphLink>(links).id(d => d.id).distance(ORBIT_R).strength(0.3))
      .force('x', d3.forceX<GraphNode>(d => d.direction === 'upstream' ? -ORBIT_R * 0.4 : (d.id === center.id ? 0 : ORBIT_R * 0.4)).strength(0.15))
      .force('y', d3.forceY<GraphNode>(0).strength(0.05))
      .alphaDecay(0.02);

    // 绘制连线（曲线）
    const linkGroup = g.append('g').attr('class', 'links');

    const linkPath = linkGroup.selectAll('path')
      .data(links)
      .enter()
      .append('path')
      .attr('fill', 'none')
      .attr('stroke', d => d.color)
      .attr('stroke-width', 2)
      .attr('stroke-opacity', 0.6)
      .attr('marker-end', d => `url(#arrow-${d.source === nodes[0] ? 'downstream' : 'upstream'})`)
      .attr('filter', 'url(#soft-shadow)');

    // 关系标签
    const linkLabelGroup = g.append('g').attr('class', 'link-labels');

    const linkLabel = linkLabelGroup.selectAll('g')
      .data(links)
      .enter()
      .append('g')
      .attr('class', 'link-label')
      .style('opacity', 0)
      .style('pointer-events', 'none');

    linkLabel.append('rect')
      .attr('rx', 4)
      .attr('ry', 4)
      .attr('fill', 'white')
      .attr('fill-opacity', 0.95)
      .attr('stroke', d => d.color)
      .attr('stroke-width', 0.5);

    linkLabel.append('text')
      .attr('text-anchor', 'middle')
      .attr('dominant-baseline', 'middle')
      .attr('font-size', '10')
      .attr('fill', '#475569')
      .text(d => truncateText(d.link.name, 6));

    // 绘制节点
    const nodeGroup = g.append('g').attr('class', 'nodes');

    const node = nodeGroup.selectAll('g')
      .data(nodes)
      .enter()
      .append('g')
      .attr('class', 'node')
      .style('cursor', d => d.id === center.id ? 'default' : 'pointer')
      .style('opacity', 0)
      .call(d3.drag<SVGGElement, GraphNode>()
        .on('start', (event, d) => {
          if (!event.active) simulation.alphaTarget(0.3).restart();
          d.fx = d.x;
          d.fy = d.y;
        })
        .on('drag', (event, d) => {
          d.fx = event.x;
          d.fy = event.y;
        })
        .on('end', (event, d) => {
          if (!event.active) simulation.alphaTarget(0);
          if (d.id !== center.id) {
            d.fx = null;
            d.fy = null;
          }
        })
      );

    // 节点外发光
    node.append('circle')
      .attr('r', d => d.r + 4)
      .attr('fill', d => d.color)
      .attr('opacity', 0.15)
      .attr('class', 'node-glow');

    // 节点主体
    node.append('circle')
      .attr('r', d => d.r)
      .attr('fill', d => {
        if (d.id === center.id) return 'url(#center-gradient)';
        return d.direction === 'upstream' ? 'url(#upstream-gradient)' : 'url(#downstream-gradient)';
      })
      .attr('stroke', d => d.color)
      .attr('stroke-width', d => d.id === center.id ? 3 : 2)
      .attr('filter', 'url(#soft-shadow)');

    // 节点文字
    node.append('text')
      .attr('text-anchor', 'middle')
      .attr('dominant-baseline', 'middle')
      .attr('font-size', d => d.id === center.id ? '13' : '11')
      .attr('font-weight', '600')
      .attr('fill', d => d.id === center.id ? 'white' : '#1e293b')
      .text(d => truncateText(d.name, d.id === center.id ? 5 : 4));

    // 关系数量徽章（多关系时）
    node.filter(d => d.links.length > 1 && d.id !== center.id)
      .append('circle')
      .attr('cx', d => d.r * 0.7)
      .attr('cy', d => -d.r * 0.7)
      .attr('r', 10)
      .attr('fill', '#f59e0b')
      .attr('stroke', 'white')
      .attr('stroke-width', 1.5);

    node.filter(d => d.links.length > 1 && d.id !== center.id)
      .append('text')
      .attr('x', d => d.r * 0.7)
      .attr('y', d => -d.r * 0.7 + 1)
      .attr('text-anchor', 'middle')
      .attr('dominant-baseline', 'middle')
      .attr('font-size', '9')
      .attr('font-weight', '700')
      .attr('fill', 'white')
      .text(d => d.links.length);

    // 入场动画
    node.transition()
      .duration(600)
      .delay((d, i) => i * 40)
      .ease(d3.easeBackOut)
      .style('opacity', 1);

    linkPath.transition()
      .duration(500)
      .delay(300)
      .attr('stroke-opacity', 0.6);

    linkLabel.transition()
      .duration(400)
      .delay(600)
      .style('opacity', 1);

    // 交互事件
    node.on('mouseenter', function(event, d) {
      d3.select(this).select('circle:nth-child(2)')
        .transition().duration(200)
        .attr('r', d.r + 4);
      d3.select(this).select('.node-glow')
        .transition().duration(200)
        .attr('r', d.r + 12)
        .attr('opacity', 0.3);

      const content = (
        <div className="max-w-xs">
          <div className="font-semibold text-slate-900">{d.name}</div>
          {d.id !== center.id && (
            <div className="text-xs text-slate-500 mt-1">
              {d.direction === 'upstream' ? '上游 OT' : '下游 OT'} · {d.links.length} 条关系
            </div>
          )}
          {d.links.length > 0 && (
            <div className="mt-2 space-y-0.5">
              {d.links.map((l, i) => (
                <div key={i} className="text-xs text-slate-600">
                  {l.name} <span className="text-slate-400">({l.cardinality})</span>
                </div>
              ))}
            </div>
          )}
          {d.ot.description && (
            <div className="text-xs text-slate-500 mt-2 line-clamp-2">{d.ot.description}</div>
          )}
        </div>
      );
      setTooltip({ x: event.clientX + 12, y: event.clientY - 12, content });
    })
    .on('mousemove', function(event) {
      setTooltip(prev => prev ? { ...prev, x: event.clientX + 12, y: event.clientY - 12 } : null);
    })
    .on('mouseleave', function(event, d) {
      d3.select(this).select('circle:nth-child(2)')
        .transition().duration(200)
        .attr('r', d.r);
      d3.select(this).select('.node-glow')
        .transition().duration(200)
        .attr('r', d.r + 4)
        .attr('opacity', 0.15);
      setTooltip(null);
    })
    .on('click', function(event, d) {
      if (d.id !== center.id) {
        onNodeClick?.(d.ot);
      }
    });

    // tick 更新
    simulation.on('tick', () => {
      linkPath.attr('d', d => {
        const s = d.source as GraphNode;
        const t = d.target as GraphNode;
        // 计算垂直偏移，产生曲线效果
        const dx = t.x! - s.x!;
        const dy = t.y! - s.y!;
        const dr = Math.sqrt(dx * dx + dy * dy);
        const curvature = 0.3;
        // 控制点：垂直于连线中点
        const mx = (s.x! + t.x!) / 2;
        const my = (s.y! + t.y!) / 2;
        const cx = mx - dy * curvature;
        const cy = my + dx * curvature;
        return `M${s.x},${s.y} Q${cx},${cy} ${t.x},${t.y}`;
      });

      node.attr('transform', d => `translate(${d.x},${d.y})`);

      linkLabel.attr('transform', d => {
        const s = d.source as GraphNode;
        const t = d.target as GraphNode;
        const mx = (s.x! + t.x!) / 2;
        const my = (s.y! + t.y!) / 2;
        return `translate(${mx},${my})`;
      });

      // 调整标签矩形大小
      linkLabel.each(function() {
        const text = d3.select(this).select('text');
        const rect = d3.select(this).select('rect');
        const bbox = (text.node() as SVGTextElement).getBBox();
        rect
          .attr('x', bbox.x - 4)
          .attr('y', bbox.y - 2)
          .attr('width', bbox.width + 8)
          .attr('height', bbox.height + 4);
      });
    });

    return () => {
      simulation.stop();
    };
  }, [center, relatedLinks, allObjects, dimensions, onNodeClick]);

  const upstreamCount = relatedLinks.filter(lt => lt.targetObjectId === center.id).length;
  const downstreamCount = relatedLinks.filter(lt => lt.sourceObjectId === center.id).length;

  return (
    <div ref={containerRef} className="w-full h-full relative">
      {/* 图例 */}
      <div className="absolute top-4 left-4 flex flex-col gap-2 bg-white/90 backdrop-blur-sm rounded-lg px-3 py-2 shadow-sm border border-slate-100 text-xs z-10">
        <div className="flex items-center gap-1.5">
          <span className="w-2.5 h-2.5 rounded-full bg-blue-500" />
          <span className="text-slate-600">上游 ({upstreamCount})</span>
        </div>
        <div className="flex items-center gap-1.5">
          <span className="w-2.5 h-2.5 rounded-full bg-emerald-500" />
          <span className="text-slate-600">下游 ({downstreamCount})</span>
        </div>
        <div className="flex items-center gap-1.5">
          <span className="w-2.5 h-2.5 rounded-full bg-indigo-600" />
          <span className="text-slate-600">中心 OT</span>
        </div>
      </div>

      <svg ref={svgRef} className="w-full h-full" />

      {/* HTML Tooltip */}
      {tooltip && (
        <div
          className="fixed z-50 pointer-events-none bg-white rounded-lg shadow-lg border border-slate-100 px-3 py-2 text-sm"
          style={{ left: tooltip.x, top: tooltip.y }}
        >
          {tooltip.content}
        </div>
      )}
    </div>
  );
};

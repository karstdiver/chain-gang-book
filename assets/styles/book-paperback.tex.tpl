% KDP paperback interior (no wrap cover). XeLaTeX via make paperback.
% Trim 6x9, no bleed. Inner margin is conservative for unknown page count.
\documentclass[11pt,twoside]{article}

\usepackage{fontspec}
\setmainfont{Times New Roman}

\usepackage{geometry}
\geometry{
  paperwidth=6in,
  paperheight=9in,
  inner=0.875in,
  outer=0.625in,
  top=0.75in,
  bottom=0.75in
}
\usepackage{setspace}
\onehalfspacing
\usepackage{parskip}

\usepackage{graphicx}
\usepackage{longtable}
\usepackage{booktabs}
\usepackage[hidelinks]{hyperref}

\usepackage{titlesec}
\titleformat{\section}{\normalfont\Large\bfseries}{\thesection}{1em}{}
\titleformat{\subsection}{\normalfont\large\bfseries}{\thesubsection}{1em}{}

\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
\providecommand{\pandocbounded}{}
\providecommand{\pandoclistitem}{}
\providecommand{\pandoclisttext}{}

$if(title)$
\title{$title$}
$endif$
$if(author)$
\author{$for(author)$$author$$sep$ \\ $endfor$}
$endif$
\date{}

\begin{document}

% Interior starts at the manuscript title page (no front-cover image).
$body$

\end{document}

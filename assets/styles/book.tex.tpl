% Minimal Pandoc LaTeX template for XeLaTeX builds
\documentclass[12pt]{article}

% Encoding & fonts
\usepackage{fontspec}
\setmainfont{Times New Roman}

% Page layout
\usepackage{geometry}
\geometry{margin=1in}
\usepackage{setspace}
\onehalfspacing
\usepackage{parskip}

% Figures, tables, links
\usepackage{graphicx}
\usepackage{longtable}
\usepackage{booktabs}
\usepackage[hidelinks]{hyperref}

% Section formatting (optional, minimal)
\usepackage{titlesec}
\titleformat{\section}{\normalfont\Large\bfseries}{\thesection}{1em}{}
\titleformat{\subsection}{\normalfont\large\bfseries}{\thesubsection}{1em}{}

% Pandoc's \tightlist helper (avoid undefined control sequence)
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}

% Additional Pandoc helpers to avoid undefined control sequences
\providecommand{\pandocbounded}{}
\providecommand{\pandoclistitem}{}
\providecommand{\pandoclisttext}{}

% Document metadata from Pandoc variables
$if(title)$
\title{$title$}
$endif$
$if(author)$
\author{$for(author)$$author$$sep$ \\ $endfor$}
$endif$
\date{}

\begin{document}

$if(title)$
\maketitle
$endif$

$if(toc)$
{\hypersetup{linkcolor=black}
\tableofcontents
\newpage}
$endif$

$body$

\end{document}



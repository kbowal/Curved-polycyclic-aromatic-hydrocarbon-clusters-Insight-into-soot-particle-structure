\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Classes/c4e-preprint}[2010/03/09 v3.0.0 c4e preprint class]

%--------------------------------------------------------------------
%    define options
%
%    como - current como preprint template
%    c4e  - previous c4e preprint template
%    cmcl - cmcl report template
%    resl - resl report template
%
%--------------------------------------------------------------------
\DeclareOption{como}{%    
    \AtBeginDocument{
        %Title page format
        \renewcommand{\maketitle}[0]{\makeCoMoTitle}%
    }
}
\DeclareOption{c4e}{%
    \AtBeginDocument{
        %Title page format
        \renewcommand{\maketitle}[0]{\makeCfETitle}%
    }
}
\DeclareOption{cmcl}{%    
    \AtEndOfClass{
        %Option hyperkink format
        \hypersetup{
             colorlinks={true},
             linkcolor={cmclblue},
             anchorcolor={cmclblue},
             citecolor={cmclblue},
             filecolor={cmclblue},
             menucolor={cmclblue},
             urlcolor={cmclblue}}%
        %Set default font family to San Serif
        \renewcommand{\familydefault}{\sfdefault}
    } 
    \AtBeginDocument{
        %Title page format
        \renewcommand{\maketitle}[0]{\makeCMCLTitle}%
    }
}
\DeclareOption{resl}{%    
    \AtBeginDocument{
        %Title page format
        \renewcommand{\maketitle}[0]{\makeRESLTitle}%
    }
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}


%--------------------------------------------------------------------
%    define required packages and commands
%--------------------------------------------------------------------
\RequirePackage{index}
\RequirePackage{xspace}

%PDF support
\ifx\pdftexversion\undefined
    %PDFTex not in use, assume output to DVI
        
        %Load graphicx with dvips option
        \RequirePackage[dvips]{graphicx} % For EPS under LaTeX
        
        %Provide dummy insertfile command
        \providecommand{\insertfile}[5]{}
        
        %Provide dummy citation index command
        \providecommand{\makeciteindex}[0]{}
    
\else
    %PDFTex in use, check output format
    \ifnum 0 < \pdfoutput
        %Output to PDF 
    
        %Load graphicx with pdftex option and use a nice font
        \RequirePackage[pdftex]{graphicx} % For PDF under PDFLaTeX
        
        \providecommand{\insertfile}[5]{
          % #1: Document text
          %     e.g., "The source code can be downloaded by clicking on the paperclip"
          % #2: File to insert (with full path)
          %     e.g., "C:/Miscell-LaTeX/Intelligent Document/macros.zip"
          % #3: PDF annotation title
          % #4: PDF annotation
          % #5: PDF attachment icon
          %     e.g., "Tag", "Attachment", "Graph" or "Paperclip"
          %
          % Used in this way, it should work correctly with LaTeX and PDFLaTeX
          #1
          \immediate\pdfobj stream
             attr {/Type /EmbeddedFile}
             file {#2}
          \makefileannotation{#3}{#4}{\the\pdflastobj}{#5}
        }
        
        \providecommand{\makefileannotation}[4]{
          % #1: PDF annotation title
          % #2: PDF annotation
          % #3: Reference to the embedded file object
          % #4: Attachment icon
          \immediate\pdfobj{
            << /F (#2)
               /Type /Filespec
               /EF << /F #3\space 0 R >>
            >>
           }
          \fileannotation{#1}{#2}{\the\pdflastobj}{#4}
        }
        
        \providecommand{\fileannotation}[4]{
          % #1: PDF annotation title
          % #2: PDF annotation
          % #3: Reference to the /Filespec object
          % #4: Attachment icon
          \pdfannot width 0.5cm depth 0.5cm {
              /Name    /#4
              /Subtype /FileAttachment
              /C [ 0 0.6 1 ]
              /T (#1)
              /Contents (#2)
              /FS #3\space 0 R
          }
        }
        
        %Citation index
        \AtBeginDocument{
            \newindex{cite}{idx}{ind}{Citation index} % citation index
            \renewcommand{\citeindextype}{cite}       % for natbib
            \citeindextrue                            % for natbib
            \providecommand{\makeciteindex}[0]{\printindex[cite][
            \addcontentsline{toc}{section}{\numberline{}Citation Index}]}
        }

    \else
    %Assume output to DVI
        
        %Load graphicx with dvips option
        \RequirePackage[dvips]{graphicx} % For EPS under LaTeX
        
        %Provide dummy insertfile command
        \providecommand{\insertfile}[5]{}
        
        %Provide dummy citation index command
        \providecommand{\makeciteindex}[0]{}
        
    \fi
\fi

%Define custom colors
\RequirePackage[usenames,dvipsnames]{color}
\definecolor{navy}{rgb}{0,0,0.5}
\definecolor{green}{rgb}{0,0.7,0.1}
\definecolor{gray}{rgb}{0.9,0.9,0.9}
\definecolor{cmclblue}{rgb}{0.05,0.57,1.00}
\definecolor{cmclgreen}{rgb}{0.2,0.8,0}

%Define default hyperkink format
\RequirePackage[hyphens]{url}
\RequirePackage[
     colorlinks={true},
     linkcolor={navy},
     anchorcolor={black},
     citecolor={green},
     linkcolor={green},
     runcolor={green},
     filecolor={magenta},
     menucolor={red},
     urlcolor={navy},
     pdfcreator={Computational Modelling Group, University of Cambridge},
     bookmarks={true},
     bookmarksopen={false},
     pdfstartview={Fit},
     pdfpagelayout={TwoPageLeft},
     pdfpagemode={UseOutlines}]{hyperref}

%Support for linespacing
\RequirePackage{setspace}

%Support for tables and figures
\RequirePackage[format=hang, labelfont={bf}, textfont={it}]{caption}
\RequirePackage{booktabs, multirow, supertabular}
%Default figure and gutter widths
\newlength{\figheight}
\newlength{\figwidth}
\newlength{\gutwidth}
\setlength{\figheight}{5cm}
\setlength{\figwidth}{0.48\columnwidth}
\setlength{\gutwidth}{0.025\columnwidth} 
%Table section heading format
\providecommand{\tablesec}[1]{\\\multicolumn{2}{l}{\textbf{#1}}\pdfbookmark[2]{#1}{#1}\\[1.00ex]}

%Support for maths
\RequirePackage{amsfonts, amsmath, amssymb, amscd, amsthm, bm, array}

%Support for chemsitry
\RequirePackage[version=3]{mhchem}

%Define citation format
\RequirePackage[numbers, sort&compress]{natbib}
\bibliographystyle{abbrvnat}
\providecommand{\doi}[1]{\href{http://dx.doi.org/#1}{doi:#1}}

%Add TOC entry to Reference section / Bibliography chapter
\AtBeginDocument{\renewcommand\refname{References  \addcontentsline{toc}{section}{\numberline{}References}  \newline}}
\AtBeginDocument{\renewcommand\bibname{Bibliography\addcontentsline{toc}{chapter}{\numberline{}Bibliography}\newline}}
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%   font control
%--------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage{times}                  % Times fonts
\RequirePackage[scaled=0.90]{couriers}  % Courier for typewriter
\RequirePackage[scaled=0.92]{helvet}    % Helvetica for sans-serif
\RequirePackage{mathptmx}               % Adobe Times Roman fonts
\DeclareMathSizes{12}{12}{8}{5}         % Tweak math font sizes
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    define document meta data commands
%--------------------------------------------------------------------
\providecommand{\nopreprint}[1]{\def\thenopreprint@{#1}}
\def\thenopreprint@{0}

\providecommand{\nopreyear}[1]{\def\thenopreyear@{#1}}
\def\thenopreyear@{\number\year}

\providecommand{\keywords}[1]{\def\thekeywords@{#1}}
\providecommand{\releasedate}[1]{\def\thereleasedate@{#1}}

\providecommand{\preprintformat}[1]{\def\usepreprintformat@{#1}}

\providecommand{\subtitle}[1]{\def\thesubtitle@{#1}}
\providecommand{\abovelogotext}[1]{\def\theabovelogotext@{#1}}
\providecommand{\belowlogotext}[1]{\def\thebelowlogotext@{#1}}
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    define document page lengths and commands
%--------------------------------------------------------------------
\setlength{\marginparwidth}{1.8cm}
\setlength{\marginparsep}{0.1cm}
\setlength{\voffset}{-1.2cm}
\setlength{\topmargin}{0pt}
\setlength{\headheight}{0pt}
\setlength{\headsep}{0pt}
\setlength{\footskip}{29pt}

\providecommand{\settextheightandwidth}[1]{
  \setlength{\hoffset}{\marginparwidth}
  \addtolength{\hoffset}{\marginparsep}
  \addtolength{\hoffset}{-1in}
  \setlength{\textwidth}{\paperwidth}%
  \addtolength{\textwidth}{-2in}%
  \addtolength{\textwidth}{-2\hoffset}%
  \addtolength{\textwidth}{-\evensidemargin}%
  \addtolength{\textwidth}{-\oddsidemargin}%

  \ifnum #1=0
    % make the margins a little bigger
    \addtolength{\textwidth}{-\marginparsep}%
    \addtolength{\textwidth}{-\marginparwidth}%
  \fi

  \setlength{\textheight}{\paperheight}%
  \addtolength{\textheight}{-2in}%
  \addtolength{\textheight}{-2\voffset}%
  \addtolength{\textheight}{-\topmargin}%
  \addtolength{\textheight}{-\headheight}%
  \addtolength{\textheight}{-\headsep}%
  \addtolength{\textheight}{-\footskip}%
}

\settextheightandwidth{1}

\providecommand\renewtextwidthandheight[2]{%
  \addtolength{\marginparwidth}{0.5\textwidth}%
  \setlength{\textwidth}{#1}%
  \addtolength{\marginparwidth}{-0.5\textwidth}%
  \addtolength{\voffset}{0.5\textheight}%
  \setlength{\textheight}{#2}%
  \addtolength{\voffset}{-0.5\textheight}%
  \settextheightandwidth{1}%
}
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    define commands to process the author affiliations
%--------------------------------------------------------------------
%Count the number of affiliations,
%each one must be specified with a separate \affiliation{}{}.
\newcounter{numauthoraffils}
\setcounter{numauthoraffils}{0}

%Write affiliation marker in superscript
\newcommand{\affiliated}[1]{\ensuremath{^{\,#1\!}}}

%This box will be used to build up a spread of institutions to which authors
%are affiliated.
\newsavebox{\authoraffils}
\newsavebox{\authoraffilrow}

%This command works by adding each new affiliation to the box stored at \authoraffils
%which is defined by the \newsavebox{\authoraffils} above.
\newcommand{\affiliation}[2]{
  %Keep count of how many different institutions there are
  \stepcounter{numauthoraffils}
  
  %The plan here is to collect together rows of upto two addresses.  To do this
  %a row is built up in the LR mode box at \authoraffilrows and the rows are stacked
  %in the vertical mode box at \authoraffils.
  
  \ifodd \value{numauthoraffils} 
   %Start a new row
    \protect\savebox{\authoraffilrow}[72mm]{
      \hspace*{2mm}
      \protect\makebox[3mm]{\raisebox{0.8ex}{\fontsize{8pt}{10pt} \selectfont {#1}}}
      \protect\parbox[t]{65mm}{\footnotesize #2}
      \hspace*{2mm}
    }
  \else 
   %This affiliation will go on the right side
    \protect\savebox{\authoraffilrow}[145mm]{
     %Get left hand half of this row
      \unhbox\authoraffilrow
      \hspace*{3mm}
      \protect\makebox[3mm]{\raisebox{0.8ex}{\fontsize{8pt}{10pt} \selectfont {#1}}}
      \protect\parbox[t]{65mm}{\footnotesize #2}
      \hspace*{2mm}
    }

    %If this is the first row the box at \authoraffils is empty and can be overwritten.
    \ifnum 2 = \value{numauthoraffils}
      \setbox \authoraffils \vbox{
        \usebox{\authoraffilrow}
      }
    \else
     %Need to add this new row to the previous rows.
      \setbox \authoraffils \vbox{
       %Get the rows that have already been stored.
        \unvbox\authoraffils
       %Add the new row.
        \usebox{\authoraffilrow}
      }
    \fi
  \fi      
}

\providecommand{\printaffliations}{
    %The author affiliations are built up into a box as they are read in.  See
    %the \affiliation command defined above for details.  Two affiliations form
    %one row and the rows are stacked up in a vertical mode box each time the
    %the second element of a row is processed in \affiliatiom.  This means that
    %if there are an odd number of affiliations then the final affiliation
    %will not be put into the vertical mode box when it is read in and this 
    %must be done now.
    \ifodd \value{numauthoraffils}
    \setbox \authoraffils \vbox{
          \unvbox\authoraffils
          \protect\makebox[145mm]{
                \hfill
                \unhbox\authoraffilrow
                \hfill
          }
    }
    \fi    
    \usebox{\authoraffils}
}
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    set commands to process keywords
%--------------------------------------------------------------------
\providecommand{\printkeywords}{
    \par
    \ifx\thekeywords@\@undefined
        \ClassWarning{c4e-preprint}{You should provide some keywords for your preprint.}
    \else
        \fontseries{m}\fontsize{10pt}{10pt}\fontshape{it} \selectfont
        %\rule{6cm}{0.5pt}\linebreak
        %\hspace*{0.0cm}Keywords and phrases:
        \rule{25mm}{1pt}\linebreak
        Keywords:\fontshape{n}\selectfont~\thekeywords@
    \fi
}
%--------------------------------------------------------------------

    
%--------------------------------------------------------------------
%    set default title page
%--------------------------------------------------------------------
\renewcommand{\maketitle}[0]{\makeCoMoTitle}
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    CoMo title page definition
%--------------------------------------------------------------------
\providecommand{\makeCoMoTitle}[0]{
    
    \pagenumbering{roman}
    
    %Title page 1 - preprint
    \thispagestyle{empty}
        
    %Preprint series information (registered with the British Library)
    %Ensure the title is the first text in the document
    \color{white}\fontsize{1pt}{1pt}\selectfont\@title\color{black}\par
    %Preprint series information in text header 
    \fontseries{m}\fontsize{10pt}{17pt}\selectfont
    Preprint \hfill Cambridge Centre for Computational Chemical Engineering  \hfill ISSN 1473 -- 4273 \par
    %Preprint series information in graphics header
    %\rule{\textwidth}{1pt}\linebreak\includegraphics[width = \textwidth]{Classes/c4e_preprint_header}\linebreak\rule{\textwidth}{1pt}
            
    %Preprint title, authors and date
    \begin{center}
        \vfill%\vspace{1.0cm}
        \fontseries{bx}\fontsize{20pt}{25pt}\selectfont
        \@title
            
        \vfill%\vspace{0.7cm}
        \fontseries{m}\fontsize{14pt}{25pt} \selectfont
        \@author \par
        
        %Show today's date unless a released date is specified
        \fontsize{12pt}{30pt} \selectfont
        \ifx \thereleasedate@ \Undefined
            Draft of \today
        \else
            released: \thereleasedate@
        \fi
    \end{center}
    
    %Affiliations
    \vspace{0.2cm}
    \vfill
    \printaffliations
    \vfill
    
    %Preprint number
    \begin{center}
        \fontseries{m}\fontsize{12pt}{30pt}\selectfont
        Preprint No. \thenopreprint@ \par
    \end{center}
        
    %University identifier
    \begin{center}
        %The univeristy guidelines stipulate that a clear area with the 
        %width of the university shield should be left around the logo
        \vfill
        \includegraphics[height = 1.0cm]{Classes/uc-pantone}\\
        \vfill
    \end{center}
    
    %Keywords
    \printkeywords
    
    %Title page 2 - credits
    \clearpage
    \thispagestyle{empty}
    \vspace*{\fill}
    
    %Details of the group which produced the preprint
    \fontseries{m}\fontsize{12pt}{14pt} \selectfont    
    \begin{tabular*}{\columnwidth}{ll@{~\extracolsep{\fill}~}r}
        \multicolumn{2}{l}{\textbf{Edited by}} & \hfill\multirow{10}{*}{\includegraphics[width = 0.2\textwidth]{Classes/group_logo_portrait_242}} \\
        \multicolumn{2}{l}{Computational Modelling Group}\\
        \multicolumn{2}{l}{Department of Chemical Engineering and Biotechnology}\\
        \multicolumn{2}{l}{University of Cambridge}\\
        \multicolumn{2}{l}{West Site, Philippa Fawcett Drive}\\
        \multicolumn{2}{l}{Cambridge, CB3 0AS}\\
        \multicolumn{2}{l}{United Kingdom}\\
        \\
        \textbf{Fax:}             &+ 44 (0)1223 334796\\
        \textbf{E-Mail:}          &\href{mailto:c4e@cam.ac.uk}{c4e@cam.ac.uk}\\
        \textbf{World Wide Web:}  &\url{http://como.cheng.cam.ac.uk/}
    \end{tabular*} 
      
     %Body pages
     \clearpage
     \pagenumbering{arabic}
}
%--------------------------------------------------------------------
    
    
%--------------------------------------------------------------------
%    c4e title page definition
%--------------------------------------------------------------------
\providecommand{\makeCfETitle}[0]{
    
    \pagenumbering{roman}
    
    %Title page 1 - preprint
    \thispagestyle{empty}
    
    %Select a big bold font
    \fontseries{bx}\fontsize{25}{25pt}\selectfont
    
    %Put the group name at the top of the title page in this big font
    \begin{center}
        Cambridge Centre for Computational Chemical Engineering
        \vspace{0.5cm}
        
        %Point out that we are from the University of Cambridge in slightly smaller type
        \fontsize{17}{25pt}\selectfont 
        University of Cambridge\\
        
        %Finally say that we are from the Dept of Chemical Engineering
        \fontseries{m}\fontsize{12}{20pt} \selectfont
        Department of Chemical Engineering and Biotechnology
        
        \par
        \vspace{0.2cm}
        
        \fontsize{14}{18pt} \selectfont
        Preprint  \hfill ISSN 1473 -- 4273
        \par
    
    \end{center}
    
    \begin{center}
        %Display the title of the preprint
        \fontseries{bx}\fontsize{17pt}{25pt} \selectfont
        \@title
    \end{center}
    
    %Display the authors of the preprint
    \fontseries{m}\fontsize{14}{30pt} \selectfont
    \begin{center}
    \@author
    \par
    
    %Show the preprint as published today unless the user specifies another
    %date, presumeably because they are correcting an earlier publication.
    \fontsize{12}{20pt} \selectfont
    \ifx \thereleasedate@ \Undefined
        Draft of \today
    \else
        released: \thereleasedate@
    \fi
    \end{center}
    
    %Authors affiliations
    \vspace{0.6cm}
    \printaffliations    
    
    %Preprint number over university crest and group logo
    \vfill
    \begin{center}
        \fontseries{m}\fontsize{12}{16pt} \selectfont
        Preprint No. \thenopreprint@\\[1mm]
        
        %University Arms
        \includegraphics[height = 14mm]{Classes/uc-arms}\\
        
        %Group logo
        \fontseries{bx}\fontsize{17}{25pt} \selectfont
        c4e    
    \end{center}
    
    %Keywords
    \printkeywords
    
    %Title page 2 - credits
    \clearpage
    \thispagestyle{empty}
    \vspace*{\fill}
    
    %Details of the group which produced the preprint
    \fontseries{m}\fontsize{12}{14pt} \selectfont
    \begin{tabular}{l}
        \textbf{Edited by}\\
        Computational Modelling Group\\
        Department of Chemical Engineering and Biotechnology\\
        University of Cambridge\\
        New Museums Site\\
        Cambridge CB2 3RA\\
        United Kingdom.
    \end{tabular}  
    
    %Contact details
    \begin{tabular}{ll}
        \textbf{Fax:}             + 44 (0)1223 334796\\
        \textbf{E-Mail:}          \href{mailto:c4e@cam.ac.uk}{c4e@cam.ac.uk}\\
        \textbf{World Wide Web:}  \url{http://como.cheng.cam.ac.uk/}
    \end{tabular}
    
    %Body pages
    \clearpage
    \pagenumbering{arabic}
}
%--------------------------------------------------------------------
    
    
%--------------------------------------------------------------------
%    Report title page definition
%--------------------------------------------------------------------
\providecommand{\makeReportTitle}[3]{
    
    \pagenumbering{roman}
    
    %Title page 1 - preprint
    \thispagestyle{empty}

    %CMCL name at the top
    \fontseries{bx}\fontsize{18}{18pt}\selectfont
    \begin{center}
        {#1}\par 
        
        \fontseries{m}\fontsize{14}{25pt} \selectfont
        \ifx \thesubtitle@ \Undefined
          use $\backslash$subtitle$\{\}$ to define this text
        \else
          \thesubtitle@
        \fi
        
        \vspace{1.5cm}    
        \par
    \end{center}
    
    %Title
    \begin{center}
        \fontseries{bx}\fontsize{18pt}{25pt} \selectfont
        \@title
    \end{center}
    
    %Display the authors of the preprint
    \fontseries{m}\fontsize{14}{30pt} \selectfont
    \begin{center}
    \@author
    \par
    
    %Show today's date unless a released date is specified
    \fontsize{12}{20pt} \selectfont
    \ifx \thereleasedate@ \Undefined
        Draft of \today
    \else
        released: \thereleasedate@
    \fi
    \end{center}
    
    %Authors affiliations
    \vspace{0.6cm}
    \printaffliations
        
    %Logo
    \vfill
    \begin{center}
          \fontseries{m}\fontsize{12}{20pt} \selectfont
          \ifx \theabovelogotext@ \Undefined
                use $\backslash$abovelogotext$\{\}$ to define this text
          \else
                \theabovelogotext@
          \fi
          \\[1mm]
        
          %CMCL Logo
          \includegraphics[height = 14mm]{#2}\\        
          \fontseries{m}\fontsize{10}{14pt} \selectfont
          \ifx \thebelowlogotext@ \Undefined
                use $\backslash$belowlogotext$\{\}$ to define this text
          \else
                \thebelowlogotext@
          \fi
          \\[20mm]      
    \end{center}
    
    %Keywords
    \printkeywords
    
    %Second page of title material - credits
    \pagebreak
    \thispagestyle{empty}
    \vspace*{\fill}
    
    %Details of the group which produced the preprint
    \fontseries{m}\fontsize{12}{14pt} \selectfont
    #3
    
    %Body pages
    \clearpage
    \pagenumbering{arabic}
}
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    CMCL title page definition
%--------------------------------------------------------------------
\providecommand{\makeCMCLTitle}[0]
{\makeReportTitle{Computational Modelling Cambridge Ltd. (CMCL)}
{Classes/cmcl}{
   \begin{tabular}{l}
    \textbf{Edited by} \\
    Computational Modelling Cambridge Ltd. \\
    Sheraton House \\
    Castle Park \\
    Cambridge CB3 0AX \\
    United Kingdom.
    \end{tabular}  
    
    %Contact details
    \begin{tabular}{ll}
    \textbf{Fax:} &+ 44 (0)1223 370040\\
    \textbf{E-Mail:} &\href{mailto:support@cmclinnovations.com}{support@cmclinnovations.com}\\
    \textbf{World Wide Web:} &\url{http://www.cmclinnovations.com}
    \end{tabular}}
}
%--------------------------------------------------------------------  


%--------------------------------------------------------------------
%    RESL title page definition
%--------------------------------------------------------------------
\providecommand{\makeRESLTitle}[0]
{\makeReportTitle{Reaction Engineering Solutions Ltd. (RESL)}
{Classes/reSolutions}{
    \begin{tabular}{l}
        \textbf{Edited by} \\
        Reaction Engineering Solutions Ltd. \\
        Sheraton House \\
        Castle Park \\
        Cambridge CB3 0AX \\
        United Kingdom.
    \end{tabular}  
    
    %Contact details
    \begin{tabular}{ll}
        \textbf{Fax:} &+ 44 (0)1223 370040\\
        \textbf{E-Mail:} &\href{mailto:support@resolutionsltd.com}{support@resolutionsltd.com}\\
        \textbf{World Wide Web:} &\url{http://www.resolutionsltd.com}
    \end{tabular}}
}
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    set document body properties
%--------------------------------------------------------------------
\renewtextwidthandheight{\textwidth}{23cm}

\parskip0.2cm
\parindent 0pt

\makeatletter\newenvironment{graybox}{%
   \begin{lrbox}{\@tempboxa}\begin{minipage}{0.985\columnwidth}}{\end{minipage}\end{lrbox}%
   \colorbox{gray}{\usebox{\@tempboxa}}\\[0.5ex]
}\makeatother
%--------------------------------------------------------------------


%--------------------------------------------------------------------
%    end class
%--------------------------------------------------------------------

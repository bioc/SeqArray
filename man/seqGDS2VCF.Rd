\name{seqGDS2VCF}
\alias{seqGDS2VCF}
\title{Convert to a VCF File}
\description{
    Converts a SeqArray GDS file to a Variant Call Format (VCF) file.
}
\usage{
seqGDS2VCF(gdsfile, vcf.fn, info.var=NULL, fmt.var=NULL, chr_prefix="",
    use_Rsamtools=TRUE, verbose=TRUE)
}
\arguments{
    \item{gdsfile}{a \code{\link{SeqVarGDSClass}} object}
    \item{vcf.fn}{the file name, output a file of VCF format; or a
        \code{\link{connection}} object}
    \item{info.var}{a list of variable names in the INFO field, or NULL for
        using all variables; \code{character(0)} for no variable
        in the INFO field}
    \item{fmt.var}{a list of variable names in the FORMAT field, or NULL for
        using all variables; \code{character(0)} for no variable
        in the FORMAT field}
    \item{chr_prefix}{the prefix of chromosome, e.g., "chr"; no prefix by
        default}
    \item{use_Rsamtools}{\code{TRUE} for loading the Rsamtools package, see
        details}
    \item{verbose}{if \code{TRUE}, show information}
}
\value{
    Return the file name of VCF file with an absolute path.
}
\details{
    \code{\link{seqSetFilter}} can be used to define a subset of data for
the export.

    If the filename extension is "gz" or "bgz", the gzip compression algorithm
will be used to compress the output data. When the Rsamtools package is
installed and \code{use_Rsamtools=TRUE}, the exported file utilizes the bgzf
format (\link[Rsamtools:zip]{bgzip}, a variant of gzip format) allowing for
fast indexing. \code{bzfile} or \code{xzfile} will be used, if the filename
extension is "bz" or "xz".
}
\references{
    Danecek, P., Auton, A., Abecasis, G., Albers, C.A., Banks, E., DePristo,
M.A., Handsaker, R.E., Lunter, G., Marth, G.T., Sherry, S.T., et al. (2011).
The variant call format and VCFtools. Bioinformatics 27, 2156-2158.
}

\author{Xiuwen Zheng}
\seealso{
    \code{\link{seqVCF2GDS}}
}

\examples{
# the GDS file
(gds.fn <- seqExampleFileName("gds"))

# display
(f <- seqOpen(gds.fn))

# output the first 10 samples
samp.id <- seqGetData(f, "sample.id")
seqSetFilter(f, sample.id=samp.id[1:5])


# convert
seqGDS2VCF(f, "tmp.vcf.gz")

# no INFO and FORMAT
seqGDS2VCF(f, "tmp1.vcf.gz", info.var=character(), fmt.var=character())

# output BN,GP,AA,DP,HM2 in INFO (the variables are in this order), no FORMAT
seqGDS2VCF(f, "tmp2.vcf.gz", info.var=c("BN","GP","AA","DP","HM2"),
    fmt.var=character())


# read
(txt <- readLines("tmp.vcf.gz", n=20))
(txt <- readLines("tmp1.vcf.gz", n=20))
(txt <- readLines("tmp2.vcf.gz", n=20))





#########################################################################
# Users could compare the new VCF file with the original VCF file
# call "diff" in Unix (a command line tool comparing files line by line)

# using all samples and variants
seqResetFilter(f)

# convert
seqGDS2VCF(f, "tmp.vcf.gz")


# file.copy(seqExampleFileName("vcf"), "old.vcf.gz", overwrite=TRUE)
# system("diff <(gunzip -c old.vcf.gz) <(gunzip -c tmp.vcf.gz)")

# 1a2,3
# > ##fileDate=20130309
# > ##source=SeqArray_RPackage_v1.0

# LOOK GOOD!


# delete temporary files
unlink(c("tmp.vcf.gz", "tmp1.vcf.gz", "tmp2.vcf.gz"))

# close the GDS file
seqClose(f)
}

\keyword{gds}
\keyword{VCF}
\keyword{sequencing}
\keyword{genetics}

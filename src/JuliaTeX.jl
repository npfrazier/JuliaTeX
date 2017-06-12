
module JuliaTeX

using Distributions

export
    tex_w,
    tex_perc,
    tex_int,
    tex_int,
    tex_3,
    tex_2,
    tex_1,
    tex_se,
    tex_results

function tex_w(fname::Union{String},ftex::Union{String})
	fid = open(fname,"w")
	write(fid,ftex)
	close(fid)
end

function tex_perc(in::Number)
	out = "$(round(Int,100*in))\\\%%"
end

function tex_int(in::Number)
	out = "$(round(Int,in))%"
end

function tex_int(in::Number,place::Int64)
	out = "$(round(in,place))%"
end

function tex_3(in::Number)
	out = "$(round(in,3))%"
end

function tex_2(in::Number)
	out = "$(round(in,2))%"
end

function tex_1(in::Number)
	out = "$(round(in,1))%"
end

function tex_se(in::Number)
	out = "($(round(in,3)))%"
end

function tex_results(
  x::Union{Float64,Array{Float64}},
  se::Union{Float64,Array{Float64}},
  llf::Float64,
  dir::String;
  names = []
  )

  ntheta = round(Int,length(x))
  if length(names) != ntheta
      println("Writing parameter names in order supplied")
      names = Array(String,ntheta) # for output table
      [names[ii] = "p$ii" for ii in 1:ntheta]
  end

	# Hypothesis Testing
  t = (x - zeros(ntheta))./se                         #vector containing z scores
  p = ones(Float64,ntheta)
  try
    p = 2(1 - Distributions.cdf(TDist(N-K-1),abs(t)))
  catch
    p = 2*(1 - 0.5 * erfc(-0.7071 * abs(t)))
  end

  function r2(in::Union{Real,Array}) # short wrapper function for round to 2nd place
      round(in,2)
  end

  fid = open(dir*"/theta_out.tex","w")
  [write(fid,"\n$(names[ii]) \n & $(tex_2(x[ii]))\n & $(tex_se(se[ii]))\n &$(tex_2(t[ii]))\n &$(tex_2(p[ii]))\n \\\\" ) for ii in 1:ntheta]
  close(fid)
  tex_w(dir*"/theta_llf.tex",tex_1(llf))
end

end

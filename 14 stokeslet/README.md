# stokeslet

Following [Graham (2018)](https://doi.org/10.1017/9781139175876), a stokeslet is the solution to a Stokes flow in an unbounded domain driven by a point force F exerted at the origin:
$$
\begin{gather}
\nabla \cdot \mathbf{u} = 0, \\
- \nabla p + \eta \nabla^2 \mathbf{u} + \mathbf{F} \delta(\mathbf{x}) = \mathbf{0}.
\end{gather}
$$

The aim of this experiment is to verify the engine correctly reproduces the analytical solution to the stokeslet. In addition to this, the flow field of a stokeslet near a wall is also studied.

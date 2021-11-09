# Case Studies in Modeling Stochastic Logic 

Written by members of the [LE/FT Lab](https://left.engr.usu.edu) at **Utah State University**, with contributions from collaborators at the **University of Utah**, **University of South Florida**, **Sandia National Laboratories,** and others.  

## Description 

This repository contains case-study models of stochastic systems, mainly using the PRISM language. Models focus on low-level computing applications and logic circuits.

## Contents

* ``./stochastic_computing/`` -- Models of *synchronous* stochastic computing circuits based on the method of [Gaines et al, 1969 (pdf)](http://pages.cpsc.ucalgary.ca/~gaines/reports/COMP/SCS69/SCS69.pdf). Specific models are placed in subdirectories:
  * ``AND/`` -- A multiplier in the unary stochastic format, using an AND gate
  * ``DIV/`` -- A divider in the unary format with memory
  * ``DIV2/`` -- Divide-by-two circuit with memory
  * ``MULT_ratioed/`` -- Multiplier in the likelihood ratio format
  * ``TFF_adder/`` -- Adder for unary and bipolar formats based on toggle flip flop
  * ``TFM/`` -- Tracking Forecast Memory used for stream regeneration

* ``./async_stochastic_computing/`` -- Models of *asynchronous* (clockless) stochastic computing circuits based on asynchronous logic methods.
* ``./causal_systems/`` -- Simple models of cause/effect processes that are pertinent to computing.
  * ``dominos/`` -- A chain of dominos that fall in sequence. One domino may randomly fail, disrupting the chain. 
* ``./fault_tolerant_logic/`` -- Models of low-level hardware techniques for mitigating faulty behavior in digital circuits.
  * ``rfb/`` -- The Restorative FeedBack method, a type of Triple-Modular Redundancy (TMR).
* ``./forward_error_correction/`` -- Error correction algorithms used for data communication, memories and data storage media.
  * ``trapping_sets/`` -- small sub-graphs affecting the *error floor* of Low-Density Parity-Check codes.

* ``./stochastic_computing/`` -- To note, the dot png is in the order (Done),(Ack),(Rdy),(Valid)

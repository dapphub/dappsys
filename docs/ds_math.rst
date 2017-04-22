
#######
DS-Math
#######

.. image:: https://img.shields.io/badge/view%20source-github-blue.svg?style=flat-square
   :target: https://github.com/dapphub/ds-math

DS-Math provides arithmetic functions for the common numerical primitive types of Solidity. You can safely add, subtract, multiply, and divide ``uint256`` and ``uint128`` numbers without fear of integer overflow. You can also conveniently find the minimum and maximum of two ``uint256``, ``uint128``, or ``int256`` numbers.

Additionally, this package provides arithmetic functions for new two higher level numerical concepts called Wad and Ray. These are used to represent decimal numbers using a ``uint128``, as the Solidity compiler does not yet support fixed-point mathematics natively (e.g. representing the number ``3.141592`` as ``3141592``). 

A Wad is a decimal number with 18 digits of precision and a Ray is a decimal number with 36 digits of precision. These functions are necessary to account for the difference between how integer arithmetic behaves normally, and how decimal arithmetic should actually work. A brief example using ``wmul``, which returns the product of two Wads:

::

    1.1 * 2.2 = 2.24

    Regular integer arithmetic adds orders of magnitude:

    110 * 220 = 22400

    Wad arithmetic does not add orders of magnitude:

    wmul(1100000000000000000, 2200000000000000000) = 2240000000000000000



**Naming Convention:** 

The standard functions are considered the ``uint256`` set, so their function names are not prefixed: ``add``, ``sub``, ``mul``, ``div``, ``min``, and ``max``.

Since ``uint128`` is half the size of the standard type, ``h`` is the prefix for this set: ``hadd``, ``hsub``, ``hmul``, ``hdiv``, ``hmin``, and ``hmax``.

The ``int256`` functions have an ``i`` prefix: ``imin``, and ``imax``.

Wad functions have a ``w`` prefix: ``wadd``, ``wsub``, ``wmul``, ``wdiv``, ``wmin``, and ``wmax``.

Ray functions have a ``r`` prefix: ``radd``, ``rsub``, ``rmul``, ``rdiv``, ``rmin``, and ``rmax``.

DSMath
======

Your contract should inherit from this type if you want to perform safe arithmetic functions on ``uint256``, ``uint128``, ``int256`` primitive types, or decimal numbers being represented with unsigned integers.

Import
------
``import ds-math/math.sol``

Parent Types
------------

None


API Reference
-------------

function add
^^^^^^^^^^^^

This function will return ``x + y`` unless it results in a ``uint256`` overflow, in which case it will throw an exception.

::

    function add(uint256 x, uint256 y) constant internal returns (uint256 z)

function sub
^^^^^^^^^^^^

This function will return ``x - y`` unless it results in a ``uint256`` overflow, in which case it will throw an exception.

::

    function sub(uint256 x, uint256 y) constant internal returns (uint256 z)

function mul
^^^^^^^^^^^^

This function will return ``x * y`` unless it results in a ``uint256`` overflow, in which case it will throw an exception.

::

    function mul(uint256 x, uint256 y) constant internal returns (uint256 z)

function div
^^^^^^^^^^^^

This function will return ``x / y`` unless ``y`` is equal to 0, in which case it will throw an exception.

::

    function div(uint256 x, uint256 y) constant internal returns (uint256 z)

function min
^^^^^^^^^^^^

This function returns the smaller number between ``x`` and ``y``.

::

    function min(uint256 x, uint256 y) constant internal returns (uint256 z)


function max
^^^^^^^^^^^^

This function returns the larger number between ``x`` and ``y``.

::

    function max(uint256 x, uint256 y) constant internal returns (uint256 z)

.. _hadd:

function hadd
^^^^^^^^^^^^^

This function will return ``x + y`` unless it results in a ``uint128`` overflow, in which case it will throw an exception.

::

    function hadd(uint128 x, uint128 y) constant internal returns (uint128 z)

.. _hsub:

function hsub
^^^^^^^^^^^^^

This function will return ``x - y`` unless it results in a ``uint128`` overflow, in which case it will throw an exception.

::

    function hsub(uint128 x, uint128 y) constant internal returns (uint128 z)

function hmul
^^^^^^^^^^^^^

This function will return ``x * y`` unless it results in a ``uint128`` overflow, in which case it will throw an exception.

::

    function hmul(uint128 x, uint128 y) constant internal returns (uint128 z)

function hdiv
^^^^^^^^^^^^^

This function will return ``x / y`` unless ``y`` is equal to 0, in which case it will throw an exception.

::

    function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z)

.. _hmin:

function hmin
^^^^^^^^^^^^^

This function returns the smaller number between ``x`` and ``y``.

::

    function hmin(uint128 x, uint128 y) constant internal returns (uint128 z)


.. _hmax:

function hmax
^^^^^^^^^^^^^

This function returns the larger number between ``x`` and ``y``.

::

    function hmax(uint128 x, uint128 y) constant internal returns (uint128 z)

function imin
^^^^^^^^^^^^^

This function returns the smaller number between ``x`` and ``y``.

::

    function imin(int256 x, int256 y) constant internal returns (int256 z)


function imax
^^^^^^^^^^^^^

This function returns the larger number between ``x`` and ``y``.

::

    function imax(int256 x, int256 y) constant internal returns (int256 z)


function wadd
^^^^^^^^^^^^^

Alias for :ref:`hadd <hadd>`.

::
    
    function wadd(uint128 x, uint128 y) constant internal returns (uint128)

function wsub
^^^^^^^^^^^^^

Alias for :ref:`hsub <hsub>`.

::
    
    function wsub(uint128 x, uint128 y) constant internal returns (uint128)

function wmul
^^^^^^^^^^^^^

This function will multiply two Wads and return a new Wad with the correct level of precision. A Wad is a decimal number with 18 digits of precision that is being represented as an integer. To learn more, see the introduction to DS-Math above.

::

    function wmul(uint128 x, uint128 y) constant internal returns (uint128 z)

function wdiv
^^^^^^^^^^^^^

This function will divide two Wads and return a new Wad with the correct level of precision. A Wad is a decimal number with 18 digits of precision that is being represented as an integer. To learn more, see the introduction to DS-Math above.

::
    
    function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z)

function wmin
^^^^^^^^^^^^^

Alias for :ref:`hmin <hmin>`.

::
    
    function wmin(uint128 x, uint128 y) constant internal returns (uint128)

function wmax
^^^^^^^^^^^^^

Alias for :ref:`hmax <hmax>`.

::
    
    function wmax(uint128 x, uint128 y) constant internal returns (uint128)

function radd
^^^^^^^^^^^^^

Alias for :ref:`hadd <hadd>`.

::
    
    function radd(uint128 x, uint128 y) constant internal returns (uint128)

function rsub
^^^^^^^^^^^^^

Alias for :ref:`hsub <hsub>`.

::
    
    function rsub(uint128 x, uint128 y) constant internal returns (uint128)

function rmul
^^^^^^^^^^^^^

This function will multiply two Rays and return a new Ray with the correct level of precision. A Ray is a decimal number with 36 digits of precision that is being represented as an integer. To learn more, see the introduction to DS-Math above.

::
    
    function rmul(uint128 x, uint128 y) constant internal returns (uint128 z)

function rdiv
^^^^^^^^^^^^^

This function will divide two Rays and return a new Ray with the correct level of precision. A Ray is a decimal number with 36 digits of precision that is being represented as an integer. To learn more, see the introduction to DS-Math above.

::

    function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z)


function rpow
^^^^^^^^^^^^^

This function will raise a Ray to the n^th power and return a new Ray with the correct level of precision. A Ray is a decimal number with 36 digits of precision that is being represented as an integer. To learn more, see the introduction to DS-Math above.

::
    
    function rpow(uint128 x, uint64 n) constant internal returns (uint128 z)

function rmin
^^^^^^^^^^^^^

Alias for :ref:`hmin <hmin>`.

::
    
    function rmin(uint128 x, uint128 y) constant internal returns (uint128)

function rmax
^^^^^^^^^^^^^

Alias for :ref:`hmax <hmax>`.

::
    
    function rmax(uint128 x, uint128 y) constant internal returns (uint128)

function cast
^^^^^^^^^^^^^

This function will transform a ``uint256`` into a ``uint128`` and return it after asserting that it is equal to the original parameter ``x``.

::

    function cast(uint256 x) constant internal returns (uint128 z)



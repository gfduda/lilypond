#ifndef __LIST_HH
#define __LIST_HH

class ostream;
template<class T> class Cursor;
template<class T> class Link;

/// all-purpose doubly linked list
template<class T>
class List
{
 public:
    List(List const&src);

    /// construct empty list                
    List();    
    virtual ~List();
	
    Cursor<T> bottom();

    int size() const;
    Cursor<T> top();
    void OK() const; 
 protected:
    friend class Cursor<T>;
    friend class Link<T>;

    void concatenate(List<T> const &s);
    

    /// make *this empty
    void set_empty();
    /**
      WARNING: contents lost, and not deleted.
      */
    
    /// add after after_me
    void add( const T& thing, Cursor<T> &after_me );

    /// put thing before #before_me#
    void insert( const T& thing, Cursor<T> &before_me );
    virtual void remove( Cursor<T> me );
    /**
      Remove link pointed to by me.

      POST
      none; WARNING: do not use #me#.
     */
    int size_;
    Link<T>* top_;
    Link<T>* bottom_;
};
/**
  a doubly linked list; 
  List can be seen as all items written down on paper,
  from top to bottom

  class Cursor is used to extend List

   items are always stored as copies in List, but:
   #List<String># :  copies of #String# stored 
   #List<String*># : copies of #String*# stored! 
   (do not use, use \Ref{PointerList} #<String*># instead.)
 
   {\bf note:} 
   retrieving "invalid" cursors, i.e. 
   #top()/bottom()# from empty list, #find()# without success,
    results in a nonvalid Cursor ( #!ok()# )


    INVARIANTEN!
*/


#include "list.inl"
#include "cursor.hh"

// instantiate a template:  explicit instantiation.
#define L_instantiate(a)  template class List<a>; template class Cursor<a>; \
  template class Link<a>


#endif // __LIST_HH //
    
   


